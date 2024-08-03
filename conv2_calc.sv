/*--- conv2_calc.sv ---*/

`timescale 1ns / 1ps

module conv2_calc (
      input [31:0] data_out [0:8],
      input clk,
      input rst_n,
      output [31:0] conv2_out [0 : filter_num -1]
      );
localparam filter_num = 64;

reg [31:0] bias [0 : filter_num -1];
reg [31:0] weight [0 : filter_num * 9 - 1];


initial begin // These are not Synthesizable!!!
   $readmemh("/home/jun/tools/project/tb_conv2_layer/conv2_weight.txt", weight); 
   $readmemh("/home/jun/tools/project/tb_conv2_layer/conv2_bias.txt", bias);
end

/*--- Filter Instantiation ---*/
genvar i;
    generate
        for (i = 0; i < 64; i = i + 1) begin : filters
            filter filter_i (
                .clk(clk),
                .rst_n(rst_n),
                .data_out(data_out),
                .bias(bias[i]),
                .weight(weight[(9*i) : (9*i)+ 8]), // weight[9*i:9*i+8]
                .filter_out(conv2_out[i])
            );
        end
     endgenerate
endmodule
