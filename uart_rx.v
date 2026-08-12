`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 16.07.2026 13:34:23
// Design Name: 
// Module Name: uart_rx_2
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


module uart_rx_2(
    input clk,
    input reset,
    input rx,
    input baud_tick,
    output reg [7:0] rx_out_byte,
    output rx_done
);

    // parameters 
    parameter   IDLE = 0,
                START = 1,
                BIT0 = 2,
                BIT1 = 3,
                BIT2 = 4,
                BIT3 = 5,
                BIT4 = 6,
                BIT5 = 7,
                BIT6 = 8,
                BIT7 = 9,
                STOP = 10,
                DONE = 11;     
                
                
    reg [3:0] cs,ns;
    
    // controller code FSM
    
    // state flip flop
    
    always @(posedge clk)
        begin
            if (reset)
                cs <= IDLE;
            else 
                cs <= ns;
        end              
        
    
    // state transition logic 
    
    always @(*)
        begin
            case (cs)
                IDLE : ns = rx ? IDLE : START;
                START : ns = baud_tick ? BIT0 : START;
                BIT0 : ns = baud_tick ? BIT1 : BIT0;
                BIT1 : ns = baud_tick ? BIT2 : BIT1;
                BIT2 : ns = baud_tick ? BIT3 : BIT2;
                BIT3 : ns = baud_tick ? BIT4 : BIT3;
                BIT4 : ns = baud_tick ? BIT5 : BIT4;
                BIT5 : ns = baud_tick ? BIT6 : BIT5;
                BIT6 : ns = baud_tick ? BIT7 : BIT6;
                BIT7 : ns = baud_tick ? STOP : BIT7;
                STOP : ns = baud_tick ? DONE : STOP;
                DONE : ns = rx ? IDLE : START;
                default : ns = IDLE;
            endcase
        end    
        
    // DATAPATH 
    
    //output logic 
    
    always @(posedge clk)
        begin
            if (reset)
                rx_out_byte <= 0;
            else 
                begin
                    case (cs)
                        BIT0 : rx_out_byte[0] <= rx;
                        BIT1 : rx_out_byte[1] <= rx;
                        BIT2 : rx_out_byte[2] <= rx;
                        BIT3 : rx_out_byte[3] <= rx;
                        BIT4 : rx_out_byte[4] <= rx;
                        BIT5 : rx_out_byte[5] <= rx;
                        BIT6 : rx_out_byte[6] <= rx;
                        BIT7 : rx_out_byte[7] <= rx;
                    endcase
                end
        end    
    
    assign rx_done = (cs == DONE);    
     
endmodule
