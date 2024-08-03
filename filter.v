`timescale 1ns / 1ps

module filter (  
   input valid_out_buf,
   input rst_n,
   input clk,
   input [31:0] bias,
   input [31:0] weight_0, weight_1, weight_2, weight_3, weight_4, weight_5, weight_6, weight_7, weight_8,
   // kernel size = 3 x 3, so input data is 9.
   input [31:0] data_out_0, data_out_1, data_out_2, data_out_3, data_out_4,data_out_5, data_out_6, data_out_7, data_out_8,                                     
   output reg [31:0] filter_out
 );

 localparam FILTER_SIZE = 3; // kenrel size = 3 x 3, so FILTER_SIZE = 3
 localparam CHANNEL_LEN = 32; // number of filters in conv1 layer is 32.

 /*----- number of filters in conv1 layer is 32, so number of weight in conv1 layer is also 32. -----*/
 wire [31:0] mul_out_0, mul_out_1, mul_out_2, mul_out_3, mul_out_4, mul_out_5, mul_out_6, mul_out_7, mul_out_8;
 wire [31:0] add_out_0, add_out_1, add_out_2, add_out_3, add_out_4, add_out_5, add_out_6, add_out_7, add_out_8;
 wire mul_valid_0, mul_valid_1,mul_valid_2,mul_valid_3,mul_valid_4,mul_valid_5,mul_valid_6,mul_valid_7, mul_valid_8;
 
 
 
/* initial begin
   $readmemh("conv1_weight_16.txt", weight); 
   $readmemh("conv1_bias_16.txt", bias);
 end */

 
/*--- float multiplier instatiation ---*/
fmultiplier fmulti_0 (
    .clk(clk),
    .rst_n(rst_n),
    .a(data_out_0),
    .b(weight_0),
    .z(mul_out_0),
    .valid(mul_valid_0)
    );
fmultiplier fmulti_1(
    .clk(clk),
    .rst_n(rst_n),
    .a(data_out_1),
    .b(weight_1),
    .z(mul_out_1),
    .valid(mul_valid_1)
    );
fmultiplier fmulti_2(
    .clk(clk),
    .rst_n(rst_n),
    .a(data_out_2),
    .b(weight_2),
    .z(mul_out_2),
    .valid(mul_valid_2)
    );
fmultiplier fmulti_3(
    .clk(clk),
    .rst_n(rst_n),
    .a(data_out_3),
    .b(weight_3),
    .z(mul_out_3),
    .valid(mul_valid_3)
    );
fmultiplier fmulti_4(
    .clk(clk),
    .rst_n(rst_n),
    .a(data_out_4),
    .b(weight_4),
    .z(mul_out_4),
    .valid(mul_valid_4)
    );      
fmultiplier fmulti_5(
    .clk(clk),
    .rst_n(rst_n),
    .a(data_out_5),
    .b(weight_5),
    .z(mul_out_5),
    .valid(mul_valid_5)
    );
fmultiplier fmulti_6(
    .clk(clk),
    .rst_n(rst_n),
    .a(data_out_6),
    .b(weight_6),
    .z(mul_out_6),
    .valid(mul_valid_6)
    );
fmultiplier fmulti_7(
    .clk(clk),
    .rst_n(rst_n),
    .a(data_out_7),
    .b(weight_7),
    .z(mul_out_7),
    .valid(mul_valid_7)
    );
fmultiplier fmulti_8(
    .clk(clk),
    .rst_n(rst_n),
    .a(data_out_8),
    .b(weight_8),
    .z(mul_out_8),
    .valid(mul_valid_8)
    );
/*----------------------------------*/
/*--- Float adder layer 1 instantiation ---*/
fadder fadder_0(
    .clk(clk),
    .A(mul_out_0),
    .B(mul_out_1),
    .result(add_out_0)
    );
fadder fadder_1(
    .clk(clk),
    .A(mul_out_2),
    .B(mul_out_3),
    .result(add_out_1)
    );
fadder fadder_2(
    .clk(clk),
    .A(mul_out_4),
    .B(mul_out_5),
    .result(add_out_2)
    );    
fadder fadder_3(
    .clk(clk),
    .A(mul_out_6),
    .B(mul_out_7),
    .result(add_out_3)
    );    
fadder fadder_4(
    .clk(clk),
    .A(mul_out_8),
    .B(bias),
    .result(add_out_4)
    );    
/*--- Float adder layer 2 instantiation ---*/
fadder fadder_5(
    .clk(clk),
    .A(add_out_0),
    .B(add_out_1),
    .result(add_out_5)
    );
fadder fadder_6(
    .clk(clk),
    .A(add_out_2),
    .B(add_out_3),
    .result(add_out_6)
    );
/*--- Float adder layer 3 instantiation ---*/
fadder fadder_7(
    .clk(clk),
    .A(add_out_5),
    .B(add_out_6),
    .result(add_out_7)
    );
/*--- Float adder layer 4 instantiation ---*/    
fadder fadder_8(
    .clk(clk),
    .A(add_out_7),
    .B(add_out_4),
    .result(add_out_8)
    );
 
always @(negedge mul_valid_0) begin
    filter_out <= add_out_8;
    end
 
endmodule

