`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 15.07.2026 21:03:11
// Design Name: 
// Module Name: uart_tx_2nd
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


module uart_tx_2nd(
    input clk,
    input baud_tick,
    input tx_start,
    input reset,
    input [7:0] tx_data, 
    output reg tx,
    output tx_done
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

    // cs = current state , ns =  next state 4 bits becasue we have total 11 states
    reg [3:0] cs,ns;                
    reg [7:0] data_reg;
     // loading the data in different register 
     
     always @(posedge clk)
        begin
            if (reset)
                data_reg <= 0;
            else 
                begin
                    if ((cs == IDLE || cs == DONE) && tx_start)
                        data_reg <= tx_data;
                end
        end
     
            
     // CONTROLLER        

    // state flip flop 
    
    always @(posedge clk)
        begin
            if (reset) cs <= IDLE;
            else cs <= ns;
        end            
                
    // state transition logic 
    always @(*)
        begin
            case (cs)
                IDLE : ns = (tx_start) ? START : IDLE;
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
                DONE : ns = tx_start ? START : IDLE;
                default : ns = IDLE;
            endcase
        end
        
        
        // DATAPATH 
        
        // otuput logic 
        
        always @(*)
            begin   
                case (cs)
                    IDLE : tx = 1'b1;
                    START : tx = 0;
                    BIT0 : tx = data_reg[0];
                    BIT1 : tx = data_reg[1];
                    BIT2 : tx = data_reg[2];
                    BIT3 : tx = data_reg[3];
                    BIT4 : tx = data_reg[4];
                    BIT5 : tx = data_reg[5];
                    BIT6 : tx = data_reg[6];
                    BIT7 : tx = data_reg[7];
                    STOP : tx = 1'b1;    
                    default : tx = 1'b1;
                endcase      
            end
    // for output tx_done make it high only for a single clock cycle 
    
    assign tx_done = (cs == DONE);
    /*always @(posedge clk)
        begin
            if (reset)
                tx_done <= 0;
            else 
                begin
                    tx_done <= 0;
                    if (cs == STOP && baud_tick) 
                        tx_done <= 1;
                end
        end*/
endmodule
