// Testbench for Conv1_layer
// 이 코드의 모든 conv1 을 conv2 or conv3로 바꾸면 conv2,3의 testbench로 활용 가능.
`timescale 1ns / 1ps


module tb_conv1_layer;

// input 
reg clk;
reg rst_n;
reg [31:0] data_in;

// output
wire [31:0] conv1_out[0:31];

// DUT instantiation
conv1_layer conv1_layer (
      .clk(clk),
      .rst_n(rst_n),
      .data_in(data_in),
      .conv1_out(conv1_out)
      );

// Clock generation
initial begin
clk = 0;
forever #5 clk = ~clk;
end
    

// Random input generation
reg [24:0] ran;
initial begin 
#5 forever #10 ran = $random;
end

initial fork
rst_n = 0;
#3 rst_n = 1;
#20 data_in = {7'b0100001,ran};
#20 forever #10 data_in = {7'b0100001,ran};
#10000 $finish;
join

endmodule
