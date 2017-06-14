`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 14.06.2017 03:38:54
// Design Name: 
// Module Name: decoder_7_seg
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


module decoder_7_seg(
input [3:0] N,
   output reg [7:0] SEG
   );

always @(*) 
begin
	case(N)
        4'd0: SEG = 8'b00000011;
        4'd1: SEG = 8'b10011111; 
        4'd2: SEG = 8'b00100101;
        4'd3: SEG = 8'b00001101;
        4'd4: SEG = 8'b10011001;
        4'd5: SEG = 8'b01001001;
        4'd6: SEG = 8'b01000001;
        4'd7: SEG = 8'b00011111;
        4'd8: SEG = 8'b00000001;
        4'd9: SEG = 8'b00001001;
        4'd10: SEG = 8'b11111101;
        default: SEG = 8'b11111111;
	endcase
	
end


endmodule
