`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 15.07.2026 18:38:32
// Design Name: 
// Module Name: baud_rate_gneraor_for_tx_Rx_2
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


module baud_rate_gneraor_for_tx_Rx_2 #(
    parameter CLK_FREQ = 100_000_000,
    parameter BAUD_RATE = 9600
)(
    input clk,
    input reset,
    output baud_tick  
);
   // parameter CLK_FREQ = 100_000_000;
   // parameter BAUD_RATE = 9600; 
   //localparam BAUD_DIV = (CLK_FREQ / BAUD_RATE);

    localparam BAUD_DIV = 10;
    reg [13:0] count;
    always @(posedge clk)
        begin
            if (reset | (count == BAUD_DIV))
                count <= 0;
            else
                count <= count + 1; 
        end
        
        assign baud_tick = (count == BAUD_DIV);
        
endmodule
