/*--- conv1_calc.v ---*/

`timescale 1ns / 1ps

module conv1_calc (
      input [31:0] data_out [0:8],
      input clk,
      input rst_n,
      output [31:0] conv1_out [0 : filter_num -1]
      );
localparam filter_num = 32;

reg [31:0] bias [0 : filter_num -1];
reg [31:0] weight [0 : filter_num * 9 - 1];


initial begin // These are not Synthesizable!!!
   $readmemh("/home/jun/tools/project/tb_conv1_layer/conv1_weight.txt", weight); 
   $readmemh("/home/jun/tools/project/tb_conv1_layer/conv1_bias.txt", bias);
end

/*--- Filter Instantiation ---*/
genvar i;
    generate
        for (i = 0; i < 32; i = i + 1) begin : filters
            filter filter_i (
                .clk(clk),
                .rst_n(rst_n),
                .data_out(data_out),
                .bias(bias[i]),
                .weight(weight[(9*i) : (9*i)+ 8]), // weight[9*i:9*i+8]
                .filter_out(conv1_out[i])
            );
        end
     endgenerate
endmodule
