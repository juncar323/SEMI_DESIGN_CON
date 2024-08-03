/* conv1_layer.v */

`timescale 1ns / 1ps

module conv1_layer(
     input clk,
     input rst_n,
     input [31:0] data_in,
     output [31:0] conv1_out [0:31]
     );
wire [31:0] data_out [0:8];
wire valid_out_buf;

/* Clock Divider : 10ns -> 80ns */
  reg [1:0] count;
  reg clk_80ns;
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            count <= 3'b11;
            clk_80ns <= 1'b0;
        end else begin
            count <= count + 1;
            if (count == 3'b11) begin
                clk_80ns <= ~clk_80ns;  
            end
        end
    end
 /*--------------------------*/

conv1_buf #(.WIDTH(28), .HEIGHT(36), .DATA_BITS(32)) conv1_buf (
   .clk(clk_80ns),
   .rst_n(rst_n),
   .data_in(data_in),
   .data_out(data_out),
   .valid_out_buf(valid_out_buf)
   );
   
conv1_calc conv1_calc (
   .clk(clk),
   .rst_n(rst_n),
   .data_out(data_out),
   .conv1_out(conv1_out)
   );
   
endmodule
