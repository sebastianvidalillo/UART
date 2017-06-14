`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 14.06.2017 03:39:35
// Design Name: 
// Module Name: UART_tx_control_wrapper
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


module UART_tx_control_wrapper
#(  parameter WAIT_FOR_RESULTADO = 1000000,
    parameter WAIT_FOR_REGISTER = 100)(
    input clock,
    input reset, 
    input PB,
    input [15:0] resultado,
    output [7:0] tx_data,
    output tx_start
    );

UART_tx_control_esclavo
#(  .WAIT_FOR_RESULTADO (WAIT_FOR_RESULTADO),
    .WAIT_FOR_REGISTER (WAIT_FOR_REGISTER)
)TX_control_inst0
(
    .clk (clock),
    .reset (reset),
    .trigger (PB),
    .send16(send16),
    .resultado (resultado),
    .tx_data (tx_data),
    .tx_start (tx_start),
    .busy (busy)
    );
    
TX_seq TX_seq_inst0
(
    .clock (clock),
    .reset (reset),
    .PB (PB),
    .busy (busy),
    .send16 (send16)
    );


endmodule
