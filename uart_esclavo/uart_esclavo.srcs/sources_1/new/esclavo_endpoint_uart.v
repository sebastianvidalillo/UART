`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 14.06.2017 03:27:26
// Design Name: 
// Module Name: esclavo_endpoint_uart
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


module esclavo_endpoint_uart(
 input CLK100MHZ,
   input CPU_RESETN,
   input uart_rx,
   output uart_tx,
   output tx_busy,
   output reg [7:0]AN,
   output CA,CB,CC,CD,CE,CF,CG,DP,
   output [3:0]LED
   );
   
   wire [15:0]op1,op2;
   wire [2:0]control;
   wire trigger;
   wire [7:0] rx_data, tx_data;
   wire rx_ready, tx_start;
   wire [15:0]resultado;
   wire [31:0]bcd;
   
   
   uart_basic #(
          .CLK_FREQUENCY(100000000),
          .BAUD_RATE(115200)
      ) uart_basic_inst (
          .clk(CLK100MHZ),
          .reset(~CPU_RESETN),
          .rx(uart_rx),
          .rx_data(rx_data),
          .rx_ready(rx_ready),
          .tx(uart_tx),
          .tx_start(tx_start),
          .tx_data(tx_data),
          .tx_busy(tx_busy)
      );

   UART_RX_CTRL 
   UART_rx_ins(
   .ready(rx_ready),
   .reset(~CPU_RESETN),
   .data(rx_data),
   .clock(CLK100MHZ),
   .operador1(op1),
   .operador2(op2),
   .control(control),
   .trigger(trigger),
   .led(LED)
   );

    wire clk_ss;
    clk_divider #(
        .O_CLK_FREQ(10000)
    ) clk_div_ss_display (
        .clk_in(CLK100MHZ),
        .reset(1'b0),
        .clk_out(clk_ss)
        );
   
   reg [3:0]counter;
       wire [3:0]counter_next;
       assign counter_next=counter+4'b1;
           
       always @(posedge clk_ss)
           begin
               counter <= counter_next;
           end
           always @(*)
           begin
               case (counter) 
                       4'd0 : AN[7:0] = 8'b11111110;
                       4'd1 : AN[7:0] = 8'b11111101;
                       4'd2 : AN[7:0] = 8'b11111011;
                       4'd3 : AN[7:0] = 8'b11110111;
                       4'd4 : AN[7:0] = 8'b11101111;
                       4'd5 : AN[7:0] = 8'b11011111;
                       4'd6 : AN[7:0] = 8'b10111111;
                       4'd7 : AN[7:0] = 8'b01111111;
                       default : AN[7:0] = 8'b11111111;
               endcase
           end
        
        
            modulo_alu1 modulo_alu1_seg_inst(
               .A(op1),
               .B(op2),
               .control(control),
               .resultado(resultado)
           );
           
               unsigned_to_bcd u32_to_bcd_inst (
               .clk(CLK100MHZ),
               .trigger(1'd1),
               .in({16'd0,resultado}),
               .idle(),
               .bcd(bcd)
           );
       
        treintaydos_to_siete treintaydos_to_siete_seg_inst(
                  .N(bcd),
                  .C(counter),
                  .SEG({CA,CB,CC,CD,CE,CF,CG,DP})
              );
        
            UART_tx_control_wrapper  
              #(.WAIT_FOR_REGISTER(100),
                .WAIT_FOR_RESULTADO(1000000))
                UART_tx_ins
              (
              .clock(CLK100MHZ),
              .reset(~CPU_RESETN),
              .PB(trigger),
              .resultado(resultado),
              .tx_data(tx_data),
              .tx_start(tx_start)
              );


endmodule
