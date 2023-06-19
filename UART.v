`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 06/19/2023 06:55:34 PM
// Design Name: 
// Module Name: UART
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


module UART(clk,rst,transmit_enable,rx,data_in,tx,tx_busy,data_ready,received_data);
input clk;
input rst;
input transmit_enable;
input rx; 
input  [7:0]data_in;
output reg tx;
output reg tx_busy;
output reg data_ready;
output reg [7:0] received_data;

parameter baud_rate = 9600;
parameter clock_freq = 50000000;


reg [3:0] tx_state;
reg [3:0] tx_bit_count;
reg [23:0] bit_counter;
 

reg [3:0]rx_state;
reg [3:0]rx_bit_count;
reg [23:0]rx_counter;


//TRANSMITTER FSM
always @(posedge clk or posedge rst)
begin 
if(rst) begin 
tx_state <= 4'b0000;
tx_bit_count <= 4'b0000;
bit_counter <= 24'b0;
tx <= 1'b1;
tx_busy <= 1'b0;
end
else
begin
case(tx_state)
4'b0000:

if(transmit_enable && !tx_busy)
begin
tx_state <= 4'b0001;
tx_bit_count <= 4'b0000;
bit_counter <= (clock_freq/baud_rate)-1;
tx <= 1'b0;
tx_busy <= 1'b1;

end

4'b0001:
if(bit_counter == 0)
begin
tx_state <= 4'b0010;
tx_bit_count <= 4'b0000;
bit_counter <= (clock_freq/baud_rate)-1;
tx <= data_in[0];
end  
4'b0010:
if(bit_counter == 0)
begin
if(tx_bit_count==7)
begin
tx_state <= 4'b0011;
tx_bit_count <= 4'b0000;
bit_counter <= (clock_freq/baud_rate)-1;
tx <= 1'b1;
end
else 
begin

tx_bit_count <= tx_bit_count +1;
tx <= data_in[tx_bit_count +1];
bit_counter <= (clock_freq/baud_rate)-1;
end
end
4'b0011:
if(bit_counter == 0)
begin
tx_state <= 4'b0000;
bit_counter <= (clock_freq/baud_rate)-1;
tx_busy <= 1'b0;
end

default:
tx_state <= 4'b0000;
endcase

if(bit_counter>0)
bit_counter <= bit_counter-1;
end

end

//RECEIVER FSM

always @(posedge clk or posedge rst)
begin
if(rst)begin 
rx_state <= 4'b0000;
rx_bit_count <= 4'b0000;
rx_counter <= 24'b0;
received_data <= 8'b0;
data_ready <= 1'b0;

end
else begin 
case (rx_state)
4'b0000:
if(rx == 1'b0) begin
rx_state <= 4'b0001;
rx_bit_count <= 4'b0000;
rx_counter <= (clock_freq/baud_rate)-1;
 end
 4'b0001:
 if(rx_counter == 0)begin
 rx_state <= 4'b0010;
 rx_bit_count <= 4'b0000;
 received_data <= 8'b0;
 rx_counter <= (clock_freq/baud_rate)-1;
 end
 4'b0010:
 if(rx_counter==0)begin 
 if(rx_bit_count == 7)begin
 rx_state <= 4'b0011;
 rx_bit_count <= 4'b0000;
 rx_counter <= (clock_freq/baud_rate)-1;
  end
  else begin
  rx_bit_count <= rx_bit_count+1;
  received_data <= {received_data[6:0],rx};
 rx_counter <= (clock_freq/baud_rate)-1;
   end
 end
 4'b0011:
 if(rx_counter == 0)
 begin
 rx_state <= 4'b0000;
 rx_bit_count <= 4'b0000;
 rx_counter <= (clock_freq/baud_rate)-1;
 end
 default:
rx_state <= 4'b0000;
endcase
if(rx_counter>0)
rx_counter <= rx_counter -1;
end
end

endmodule
