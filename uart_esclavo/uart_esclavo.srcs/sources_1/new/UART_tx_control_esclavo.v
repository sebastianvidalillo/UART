`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 14.06.2017 03:40:34
// Design Name: 
// Module Name: UART_tx_control_esclavo
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


module UART_tx_control_esclavo
#( parameter WAIT_FOR_REGISTER = 100,
   parameter WAIT_FOR_RESULTADO = 1000000)(
 
 input clk,
 input reset,
 input trigger,
 input [15:0]resultado,
 input send16,
 output reg busy,
 output reg [7:0] tx_data,
 output reg tx_start
 );
 
 reg [3:0] next_state, state;
 reg [15:0] tx_data16;
 reg [31:0] cnt_next;
 
 localparam IDLE 		    = 3'd0;  
 localparam REGISTER_DATAIN = 3'd1; 
 localparam SEND_BYTE_0     = 3'd2;  
 localparam DELAY_BYTE_0    = 3'd3;  
 localparam SEND_BYTE_1     = 3'd4;  
 localparam DELAY_BYTE_1    = 3'd5;

 
 always@(*) begin
    
    next_state = state;
    busy = 1'b1;
    tx_start = 1'b0;
    tx_data = tx_data16[7:0];
    
    case (state)
        IDLE: begin
                busy = 1'b0;
                if (trigger)
                    next_state = REGISTER_DATAIN;
              end
              
        REGISTER_DATAIN: begin
                        if (cnt_next >= WAIT_FOR_REGISTER)begin
                            next_state = SEND_BYTE_0;
                            end
                      end
                        
        SEND_BYTE_0: begin 
                     next_state = DELAY_BYTE_0;
                     tx_start = 1'b1;
                     end

        DELAY_BYTE_0: begin
                        //tx_data = tx_data16[15:8];
                        if (cnt_next >= WAIT_FOR_RESULTADO) begin
                                if (send16)
                                    next_state=SEND_BYTE_1;
                                else 
                                    next_state=IDLE;
                                end
                       end
         SEND_BYTE_1: begin
                        tx_data = tx_data16[15:8];
                        next_state = DELAY_BYTE_1;
                        tx_start = 1'b1;
                      end
         DELAY_BYTE_1: begin
                       if (cnt_next >= WAIT_FOR_RESULTADO)
                                 next_state=IDLE;
                       else
                            next_state=DELAY_BYTE_1;
                       end
         default: next_state = IDLE;
         endcase
         end    
         
  always@(posedge clk) begin
    if (reset)
        state <= IDLE;
    else 
        state <= next_state;
    end
    
  always@(posedge clk) begin
        if (state ==REGISTER_DATAIN)
            tx_data16 <= resultado;
        end
        
  always@(posedge clk) begin
    if (state == DELAY_BYTE_0 || state == DELAY_BYTE_1 || state == REGISTER_DATAIN)begin
        cnt_next <= cnt_next + 1;
        end
    else begin
        cnt_next <=0;
        end
    end  


endmodule
