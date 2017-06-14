`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 14.06.2017 03:41:27
// Design Name: 
// Module Name: TX_seq
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


module TX_seq(
input clock,
input reset,
input PB,
output reg send16,
input busy
    );
    
reg[1:0] next_state, state;

localparam IDLE = 2'd0;
localparam TX_RESULTADO = 2'd1;

always@(*) begin
next_state = state;
send16 = 1'b1;
case(state)
IDLE: begin
        if(PB & ~busy) begin
            next_state = TX_RESULTADO;
            end end
TX_RESULTADO: begin
                if(~busy) begin
                    next_state = IDLE;
                    end end
                    endcase
                    end
                    
always@(posedge clock) begin
    if(reset)
        state <= IDLE;
    else
        state <= next_state;
        end

endmodule
