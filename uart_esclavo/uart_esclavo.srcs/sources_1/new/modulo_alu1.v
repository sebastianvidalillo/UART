`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 14.06.2017 03:35:17
// Design Name: 
// Module Name: modulo_alu1
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


module modulo_alu1(
input [15:0]A,
        input [15:0]B,
        input [2:0] control,
        output reg [15:0]resultado
        );
        always@(*)
        begin
            case(control)
                3'b001: resultado = A + B;
                3'b010: resultado = (A>B)?(A-B):(B-A);
                3'b011: resultado = A*B;
                3'b101: resultado = A|B;
                3'b100: resultado = A&B;
                3'b110: resultado = A;
                3'b111: resultado = B;
                
                default: resultado = 16'b0;               
            endcase
        end



endmodule
