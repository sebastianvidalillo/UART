`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 14.06.2017 03:33:42
// Design Name: 
// Module Name: UART_RX_CTRL
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


module UART_RX_CTRL(
input ready,
    input reset,  /*falta agregar el reset para que en caso que se aprete reset vuelva a la primera maquina de estaado*/
    input [7:0]data,
    input clock,
    output reg [15:0]operador1,
    output reg [15:0]operador2,
    output reg [2:0]control,
    output reg trigger,
    output reg [3:0]led
    );
    
    localparam Wait_Op1_LSP      = 4'b0001;
    localparam Store_Op1_LSB     = 4'b0010;
    localparam Wait_Op1_MSB      = 4'b0011;
    localparam Store_Op1_MSB     = 4'b0100;
    localparam Wait_Op2_LSP      = 4'b0101;
    localparam Store_Op2_LSB     = 4'b0110;
    localparam Wait_Op2_MSB      = 4'b0111;
    localparam Store_Op2_MSB     = 4'b1000;
    localparam Wait_CMD          = 4'b1001;
    localparam Store_CMD         = 4'b1010;
    localparam Delay_1_Cycle     = 4'b1011;
    localparam Trigger_TX_result = 4'b1100;
    
    reg [3:0]estado, estado_sig;
    reg [15:0]save1,save1_next, save2,save2_next;
    reg [15:0] operador1_next, operador2_next;
    reg [3:0]control_next;
    reg [31:0] cnt, cnt_next;
    
    always@(*)begin
    trigger = 1'b0;
    estado_sig=Wait_Op1_LSP;
    led=estado;
    operador1_next=operador1;
    operador2_next=operador2;
    save1_next=save1;
    save2_next=save2;
    control_next=control;
    case(estado)
        Wait_Op1_LSP : begin
            if(ready)
                estado_sig=Store_Op1_LSB;
            else
                estado_sig=Wait_Op1_LSP;
            end
        Store_Op1_LSB : begin
            estado_sig=Wait_Op1_MSB;
            save1_next[7:0]=data;
            end

        Wait_Op1_MSB : begin
            if(ready)
                estado_sig=Store_Op1_MSB;
            else
                estado_sig=Wait_Op1_MSB;
            end
        Store_Op1_MSB : begin
            estado_sig=Wait_Op2_LSP;
            save1_next[15:8]=data;
            end
            
        Wait_Op2_LSP : begin
                operador1_next = save1;
                control_next = 3'b110;
                if(ready)
                   estado_sig=Store_Op2_LSB;
                else
                    estado_sig=Wait_Op2_LSP;
            end
        Store_Op2_LSB : begin
            save2_next[7:0]=data;
            estado_sig=Wait_Op2_MSB;
            end
            
            
        Wait_Op2_MSB : begin
            if(ready)
                estado_sig=Store_Op2_MSB;
            else
                estado_sig=Wait_Op2_MSB;
            end
        Store_Op2_MSB : begin
            save2_next[15:8]=data;
            estado_sig=Wait_CMD;

            end
        Wait_CMD : begin
            control_next = 3'b111;
            operador2_next = save2;
            if(ready)
                estado_sig=Store_CMD;
            else
                estado_sig=Wait_CMD;
            end
        Store_CMD : begin
            control_next=data[2:0];
            estado_sig=Delay_1_Cycle;
            end
         
        Delay_1_Cycle :
            estado_sig=Trigger_TX_result;
          
        Trigger_TX_result : begin
             operador1_next=save1;
             operador2_next=save2;
             trigger = 1'b1;
             estado_sig=Wait_Op1_LSP;
             end
            
        default : estado_sig=Wait_Op1_LSP;
    endcase
    end
    
  /*  always@(*)begin
        save1_next=save1;
        save2_next=save2;
        case (estado)
         Store_Op1_LSB:
            save1_next[7:0]= data;
         Store_Op1_MSB:
            save1_next[15:8]=data;
         Store_Op2_LSB:
            save2_next[7:0]=data;
         Store_Op2_MSB:
            save2_next[15:8]=data;
         Store_CMD:
            control_next=data[2:0];*/
            
    
    
    
    
    always@(posedge clock)begin
        if (reset) begin
            estado <= Wait_Op1_LSP;
            end
        else
            estado<=estado_sig;
    end
    
    always@(posedge clock or posedge reset)begin
        if (reset) begin
            operador1 <= 16'd0;
            operador2 <= 16'd0;
            control   <= 3'd0;
            save1     <=16'd0;
            save2     <= 16'd0;
            end
        else begin
            operador1 <= operador1_next;
            operador2 <= operador2_next;
            control <= control_next;
            save1 <= save1_next;
            save2 <= save2_next;
            end
       end


endmodule
