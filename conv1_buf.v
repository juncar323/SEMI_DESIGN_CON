module conv1_buf #(parameter WIDTH = 28, HEIGHT = 36, DATA_BITS = 32)( // HEIGHT : 28 -> 36 , DATA_BITS = 32 (float)
   input clk,
   input rst_n, // synchronous reset
   input [DATA_BITS - 1:0] data_in,
   output reg [DATA_BITS - 1:0] data_out_0, data_out_1, data_out_2, data_out_3, data_out_4,
   data_out_5, data_out_6, data_out_7, data_out_8,
   output reg valid_out_buf
 );

 localparam FILTER_SIZE = 3;// kernel size = 3x3, so FILTER_SIZE = 3

 reg [DATA_BITS - 1:0] buffer [0:WIDTH * FILTER_SIZE - 1];
 reg [6:0] buf_idx; // number of buffer is 28*3 = 84. 84 = 1010100 -> 7bit. so buf_idx = 7bit.
 reg [2:0] w_idx, h_idx; // kernel size is 3x3, so w_idx, h_idx = 3bit
 reg [1:0] buf_flag;  // To express 0, 1, 2 (3 state)
 reg state;

 always @(posedge clk) begin
 /*--------- reset code ----------*/  
   if(~rst_n) begin
     buf_idx <= -1; // At next cycle, buf_idx will be zero.
     w_idx <= 0;
     h_idx <= 0;
     buf_flag <= 0;
     state <= 0;
     valid_out_buf <= 0;
     data_out_0 <= 32'bx;
     data_out_1 <= 32'bx;
     data_out_2 <= 32'bx;
     data_out_3 <= 32'bx;
     data_out_4 <= 32'bx;
     data_out_5 <= 32'bx;
     data_out_6 <= 32'bx;
     data_out_7 <= 32'bx;
     data_out_8 <= 32'bx;
 /*------------------------------*/    
 
 
   end else begin
   buf_idx <= buf_idx + 1;
   if(buf_idx == WIDTH * FILTER_SIZE - 1) begin // buffer size = 84 = 28(w) * 3(h)
     buf_idx <= 0;
   end
   
   buffer[buf_idx] <= data_in;  // data input
     
   // Wait until first 84 input data filled in buffer
   if(!state) begin
     if(buf_idx == WIDTH * FILTER_SIZE - 1) begin
       state <= 1'b1; 
     end
   end else begin // valid state
     w_idx <= w_idx + 1'b1; // move right

     if(w_idx == WIDTH - FILTER_SIZE + 1) begin
       valid_out_buf <= 1'b0; // unvalid area
     end else if(w_idx == WIDTH - 1) begin
       buf_flag <= buf_flag + 1'b1;
       if(buf_flag == FILTER_SIZE - 1) begin
         buf_flag <= 0;
       end
       w_idx <= 0;

       if(h_idx == HEIGHT - FILTER_SIZE) begin  // done 1 input read -> 28 * 28
         h_idx <= 0;
         state <= 1'b0;
       end 
       
       h_idx <= h_idx + 1'b1;

     end else if(w_idx == 0) begin
       valid_out_buf <= 1'b1; // start valid area
     end

     // Buffer Selection -> 3x3
     if(buf_flag == 3'd0) begin
       data_out_0 <= buffer[w_idx];
       data_out_1 <= buffer[w_idx + 1];
       data_out_2 <= buffer[w_idx + 2];
       
       data_out_3 <= buffer[w_idx + WIDTH];
       data_out_4 <= buffer[w_idx + WIDTH + 1];
       data_out_5 <= buffer[w_idx + WIDTH + 2];
       
       data_out_6 <= buffer[w_idx + WIDTH*2];
       data_out_7 <= buffer[w_idx + WIDTH*2 + 1];
       data_out_8 <= buffer[w_idx + WIDTH*2 + 2];

     end else if(buf_flag == 3'd1) begin
       data_out_0 <= buffer[w_idx + WIDTH];
       data_out_1 <= buffer[w_idx + WIDTH + 1];
       data_out_2 <= buffer[w_idx + WIDTH + 2];
       
       data_out_3 <= buffer[w_idx + WIDTH * 2];
       data_out_4 <= buffer[w_idx + WIDTH * 2 + 1];
       data_out_5 <= buffer[w_idx + WIDTH * 2 + 2];
       
       data_out_6 <= buffer[w_idx];
       data_out_7 <= buffer[w_idx + 1];
       data_out_8 <= buffer[w_idx + 2];

     end else if(buf_flag == 3'd2) begin
       data_out_0 <= buffer[w_idx + WIDTH * 2];
       data_out_1 <= buffer[w_idx + WIDTH * 2 + 1];
       data_out_2 <= buffer[w_idx + WIDTH * 2 + 2];
       
       data_out_3 <= buffer[w_idx];
       data_out_4 <= buffer[w_idx + 1];
       data_out_5 <= buffer[w_idx + 2];
       
       data_out_6 <= buffer[w_idx + WIDTH];
       data_out_7 <= buffer[w_idx + WIDTH + 1];
       data_out_8 <= buffer[w_idx + WIDTH + 2];

     end
   end
   end
 end
endmodule



/* test bench
`timescale 1ns / 1ps

module tb_conv1_buf();
reg clk;
reg rst_n;
wire [31:0] data_out_0, data_out_1, data_out_2, data_out_3, data_out_4, data_out_5, data_out_6, data_out_7, data_out_8;
reg [31:0] data_in;
wire valid_out_buf;
conv1_buf #(.WIDTH(28), .HEIGHT(36), .DATA_BITS(32)) conv1_buf (
   .clk(clk),
   .rst_n(rst_n),
   .data_in(data_in),
   .data_out_0(data_out_0),
   .data_out_1(data_out_1),
   .data_out_2(data_out_2),
   .data_out_3(data_out_3),
   .data_out_4(data_out_4),
   .data_out_5(data_out_5),
   .data_out_6(data_out_6),
   .data_out_7(data_out_7),
   .data_out_8(data_out_8),
   .valid_out_buf(valid_out_buf)
   );
initial fork
clk = 0;
forever #40 clk = ~clk;
#10 forever #80 data_in = $random;
rst_n = 0;
#50 
rst_n = 1;
#16000 
$stop;

join

endmodule */

