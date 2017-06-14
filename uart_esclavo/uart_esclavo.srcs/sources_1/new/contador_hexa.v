`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 14.06.2017 03:38:10
// Design Name: 
// Module Name: contador_hexa
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


module contador_hexa(
input [31:0] N,
    input [3:0] C,
    output reg [3:0] H
    );
    always @(*)
    begin
        case(C)
            4'd0: H = N[3:0];
            4'd1: H = N[7:4];
            4'd2: H = N[11:8];
            4'd3: H = N[15:12];
            4'd4: H = N[19:16];
            4'd5: H = N[23:20];
            4'd6: H = N[27:24];
            4'd7: H = N[31:28];
            default: H = 4'd0;
        endcase
    end


endmodule
