`timescale 1ns / 1ps


module filter ( 
   input clk,
   input rst_n,
   input [31:0] bias,
   input [31:0] weight[0:8],
   // kernel size = 3 x 3, so input data is 9.
   input [31:0] data_out [0:8],                                     
   output reg [31:0] filter_out
 );

 localparam FILTER_SIZE = 3; // kenrel size = 3 x 3, so FILTER_SIZE = 3

 /*----- number of filters in conv1 layer is 32, so number of weight in conv1 layer is also 32. -----*/
 wire [31:0] mul_out_0, mul_out_1, mul_out_2, mul_out_3, mul_out_4, mul_out_5, mul_out_6, mul_out_7, mul_out_8;
 wire [31:0] add_out_0, add_out_1, add_out_2, add_out_3, add_out_4, add_out_5, add_out_6, add_out_7, add_out_8;
 wire mul_valid_0, mul_valid_1,mul_valid_2,mul_valid_3,mul_valid_4,mul_valid_5,mul_valid_6,mul_valid_7, mul_valid_8;
 
 
 
/*--- float multiplier instatiation ---*/
fmultiplier fmulti_0 (
    .clk(clk),
    .rst_n(rst_n),
    .a(data_out[0]),
    .b(weight[0]),
    .z(mul_out_0),
    .valid(mul_valid_0)
    );
fmultiplier fmulti_1(
    .clk(clk),
    .rst_n(rst_n),
    .a(data_out[1]),
    .b(weight[1]),
    .z(mul_out_1),
    .valid(mul_valid_1)
    );
fmultiplier fmulti_2(
    .clk(clk),
    .rst_n(rst_n),
    .a(data_out[2]),
    .b(weight[2]),
    .z(mul_out_2),
    .valid(mul_valid_2)
    );
fmultiplier fmulti_3(
    .clk(clk),
    .rst_n(rst_n),
    .a(data_out[3]),
    .b(weight[3]),
    .z(mul_out_3),
    .valid(mul_valid_3)
    );
fmultiplier fmulti_4(
    .clk(clk),
    .rst_n(rst_n),
    .a(data_out[4]),
    .b(weight[4]),
    .z(mul_out_4),
    .valid(mul_valid_4)
    );      
fmultiplier fmulti_5(
    .clk(clk),
    .rst_n(rst_n),
    .a(data_out[5]),
    .b(weight[5]),
    .z(mul_out_5),
    .valid(mul_valid_5)
    );
fmultiplier fmulti_6(
    .clk(clk),
    .rst_n(rst_n),
    .a(data_out[6]),
    .b(weight[6]),
    .z(mul_out_6),
    .valid(mul_valid_6)
    );
fmultiplier fmulti_7(
    .clk(clk),
    .rst_n(rst_n),
    .a(data_out[7]),
    .b(weight[7]),
    .z(mul_out_7),
    .valid(mul_valid_7)
    );
fmultiplier fmulti_8(
    .clk(clk),
    .rst_n(rst_n),
    .a(data_out[8]),
    .b(weight[8]),
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

