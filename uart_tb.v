`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 16.07.2026 16:43:03
// Design Name: 
// Module Name: uart_tb
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


module uart_tb;

    reg clk;
    reg reset;
    reg [7:0] tx_data;
    reg tx_start;
    
    wire baud_tick;
    wire tx;
    wire tx_done;
    
    wire rx;
    wire [7:0] rx_out_byte;
    wire rx_done;
    
    assign rx = tx;
    
    // instantiating baud rate generator 
    baud_rate_gneraor_for_tx_Rx_2 bg(
        .clk(clk),
        .reset(reset),
        .baud_tick(baud_tick)
    );
    
    // instantiating the transmitter 
    
    uart_tx_2nd uut(
        .clk(clk),
        .reset(reset),
        .tx_data(tx_data),
        .tx_start(tx_start),
        .baud_tick(baud_tick),
        .tx_done(tx_done),
        .tx(tx)                    
    );
    
    
    // instantiating the receiver module 
    
    uart_rx_2 rx_unit(
        .clk(clk),
        .reset(reset),
        .baud_tick(baud_tick),
        .rx(rx),
        .rx_out_byte(rx_out_byte),
        .rx_done(rx_done)
    );
    
    // clock generation
    
    always #5 clk = ~clk;
    
    // the main excitation and verification logic 
    initial 
        begin
            // initialize to 0
            clk = 0;
            reset = 1;
            tx_start = 0;
            tx_data = 8'b10101100;
            
            // reset pulse 
            #10 reset = 0;
            
            //start transmission
            #10 tx_start = 1;
            #10 tx_start = 0;
            
            // wait for the receiver to finish and check the received bytes 
            
            @(posedge rx_done);
            #1;
            if (rx_out_byte == tx_data)
                $display("PASS : rx_out_byte = %b , tx_data = %b",rx_out_byte,tx_data);
            else 
                $display("FAIL : rx_out_byte = %b , tx_data = %b",rx_out_byte,tx_data);
            // small delay so that th eresults are visible 
            
            #20;
            
            $finish;
            
        end
    
endmodule
