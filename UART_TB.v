`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 06/19/2023 08:52:30 PM
// Design Name: 
// Module Name: UART_TB
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////

module UART_Testbench;
  reg clk;
  reg rst;
  reg transmit_enable;
  reg rx;
  reg [7:0] data_in;
  wire tx;
  wire tx_busy;
  wire data_ready;
  wire [7:0] received_data;

 
  UART uart (
    .clk(clk),
    .rst(rst),
    .rx(rx),
    .tx(tx),
    .data_in(data_in),
    .received_data(received_data),
    .tx_busy(tx_busy),
    .transmit_enable(transmit_enable),
    .data_ready(data_ready)
  );

  
  always #5 clk = ~clk;

  
  initial begin
    clk = 0;
    rst = 1;
    transmit_enable = 0;
    rx = 0;
    data_in = 8'b0;

    #10 rst = 0; 
    #20 transmit_enable = 1;
    data_in = 8'b11011010; 
    #100 transmit_enable = 0;

    
    #200;
    if (data_ready) begin
      $display("Received Data: %h", received_data);
    end
    #10 $finish; 
  end

  
  always @(posedge clk) begin
    if (tx_busy)
      rx <= #5 ~rx; 
  end

endmodule