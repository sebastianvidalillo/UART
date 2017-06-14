`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 14.06.2017 03:34:31
// Design Name: 
// Module Name: clk_divider
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


module clk_divider
#(
	parameter O_CLK_FREQ = 1
)(
	input clk_in,
	input reset,
	output reg clk_out
);

	/*
	 * Calculamos el valor máximo que nuestro contador debe alcanzar en función
	 * de O_CLK_FREQ
	 */
	localparam COUNTER_MAX = 'd100_000_000/(2 * O_CLK_FREQ) - 1;

	reg [26:0] counter = 'd0;

	/*
	 * Bloque procedural que resetea el contador e invierte el valor del reloj de salida
	 * cada vez que el contador llega a su valor máximo.
	 */
	always @(posedge clk_in) begin
		if (reset == 1'b1) begin
			// Señal reset sincrónico, setea el contador y la salida a un valor conocido
			counter <= 'd0;
			clk_out <= 0;
		end else if (counter == COUNTER_MAX) begin
			// Se resetea el contador y se invierte la salida
			counter <= 'd0;
			clk_out <= ~clk_out;
		end else begin
			// Se incrementa el contador y se mantiene la salida con su valor anterior
			counter <= counter + 'd1;
			clk_out <= clk_out;
		end
	end



endmodule
