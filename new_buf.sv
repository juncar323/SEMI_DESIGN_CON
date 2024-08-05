module conv3_buf #(parameter WIDTH = 8, HEIGHT = 10, DATA_BITS = 32)( 
   input clk,
   input rst_n, 
   input valid_in,
   input [DATA_BITS - 1:0] data_in,
   output reg [DATA_BITS - 1:0] data_out[0:8],
   output reg valid_out_buf
 );

 localparam FILTER_SIZE = 3;// kernel size = 3x3, so FILTER_SIZE = 3

 reg [DATA_BITS - 1:0] buffer [0:WIDTH * FILTER_SIZE - 1];
 reg [5:0] buf_idx; // number of buffer is 8*3 = 24. 45 = 101101  -> 6bit. so buf_idx = 6bit.
 reg  buf_valid; // To synchronize buffer and stride 's speed.
  reg [1:0] buf_cnt;
 reg [4:0] w_idx;
 reg [4:0] h_idx;
 reg [1:0] buf_flag;  // To express 0, 1, 2 (3 state)
 reg state;
 
 always @(posedge clk or negedge rst_n) begin
 /*--------- reset code ----------*/  
   if(!rst_n) begin
      buf_idx <= 0; 
      w_idx <= 0;
      h_idx <= 0;
      buf_flag <= 0;
      state <= 0;
      buf_valid <= 0;
      buf_cnt <= 0;
      valid_out_buf <= 0;
      data_out[0] <= 32'bx;
      data_out[1] <= 32'bx;
      data_out[2] <= 32'bx;
      data_out[3] <= 32'bx;
      data_out[4] <= 32'bx;
      data_out[5] <= 32'bx;
      data_out[6] <= 32'bx;
      data_out[7] <= 32'bx;
      data_out[8] <= 32'bx;
 /*------------------------------*/

 /*--- When Data is done. ---*/
   end else if (h_idx == HEIGHT -FILTER_SIZE + 2 |valid_in == 0) begin
      valid_out_buf <= 0;
      data_out[0] <= 32'bx;
      data_out[1] <= 32'bx;
      data_out[2] <= 32'bx;
      data_out[3] <= 32'bx;
      data_out[4] <= 32'bx;
      data_out[5] <= 32'bx;
      data_out[6] <= 32'bx;
      data_out[7] <= 32'bx;
      data_out[8] <= 32'bx;
/*---------------------------*/
/*--- buf_fiiling ---*/
     end else begin
     buf_idx <= buf_idx + 1;
     if(buf_idx == WIDTH * FILTER_SIZE - 1) begin 
       buf_idx <= 0;
     end
   
     buffer[buf_idx] <= data_in;  // data input
     
   // Wait until first 84 input data filled in buffer
   if(!state) begin
     if(buf_idx == WIDTH * FILTER_SIZE - 1) begin
       state <= 1'b1;
     end
   // buf is full. Data_out start.  
   end else if (buf_cnt == 2'b10) begin // valid state
     w_idx <= w_idx + 1'b1; // move right

     if(w_idx == WIDTH - FILTER_SIZE) begin //if(w_idx == WIDTH - FILTER_SIZE + 1) begin
       w_idx <= 0;
       h_idx <= h_idx + 1'b1;
       buf_flag <= buf_flag + 1'b1;
       if(buf_flag == FILTER_SIZE - 1) begin
         buf_flag <= 0;
       end

     end else if(w_idx == 0) begin
       valid_out_buf <= 1'b1; // start valid area
     end
     end
   end
 end

  always @(posedge clk) begin
    if ((buf_idx == WIDTH - FILTER_SIZE -1 | buf_idx == (2 * WIDTH) - FILTER_SIZE - 1 | buf_idx == (3 * WIDTH) - FILTER_SIZE - 1)& state) begin
      buf_cnt <= buf_cnt + 1;
      buf_valid <= 0;
    end else if (buf_cnt == 2'b10) begin
      buf_cnt <= 0;
      buf_valid <= 1;
    end
  end
  
  always @(posedge clk) begin
    if (buf_valid == 1) begin
     // Buffer Selection -> 3x3
        if(buf_flag == 3'd0) begin
        data_out[0] <= buffer[w_idx];
        data_out[1] <= buffer[w_idx + 1];
        data_out[2] <= buffer[w_idx + 2];
       
        data_out[3] <= buffer[w_idx + WIDTH];
        data_out[4] <= buffer[w_idx + WIDTH + 1];
        data_out[5] <= buffer[w_idx + WIDTH + 2];
       
        data_out[6] <= buffer[w_idx + WIDTH*2];
        data_out[7] <= buffer[w_idx + WIDTH*2 + 1];
        data_out[8] <= buffer[w_idx + WIDTH*2 + 2];

        end else if(buf_flag == 3'd1) begin
        data_out[0] <= buffer[w_idx + WIDTH];
        data_out[1] <= buffer[w_idx + WIDTH + 1];
        data_out[2] <= buffer[w_idx + WIDTH + 2];
       
        data_out[3] <= buffer[w_idx + WIDTH * 2];
        data_out[4] <= buffer[w_idx + WIDTH * 2 + 1];
        data_out[5] <= buffer[w_idx + WIDTH * 2 + 2];
       
        data_out[6] <= buffer[w_idx];
        data_out[7] <= buffer[w_idx + 1];
        data_out[8] <= buffer[w_idx + 2];

        end else if(buf_flag == 3'd2) begin
        data_out[0] <= buffer[w_idx + WIDTH * 2];
        data_out[1] <= buffer[w_idx + WIDTH * 2 + 1];
        data_out[2] <= buffer[w_idx + WIDTH * 2 + 2];
       
        data_out[3] <= buffer[w_idx];
        data_out[4] <= buffer[w_idx + 1];
        data_out[5] <= buffer[w_idx + 2];
       
        data_out[6] <= buffer[w_idx + WIDTH];
        data_out[7] <= buffer[w_idx + WIDTH + 1];
        data_out[8] <= buffer[w_idx + WIDTH + 2];
          // 래치 생길라나?
    end
  end
endmodule
