`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 14.06.2017 03:37:18
// Design Name: 
// Module Name: treintaydos_to_siete
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


module treintaydos_to_siete(
input [31:0]N,
    input [3:0]C,
    output wire [7:0]SEG
    );
    wire [3:0]H;
    
    contador_hexa contado_hexa_seg_inst(
        .N(N),
        .C(C),
        .H(H)
    );
    decoder_7_seg decoder_7_seg_seg_inst(
        .N(H),
        .SEG(SEG)
    );


endmodule
