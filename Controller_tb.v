`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 09/28/2022 09:33:42 PM
// Design Name: 
// Module Name: Controller_tb
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


module Controller_tb(

    );
 reg [4:0] opCode =5'b00000;
 reg D =0;     //destination
 reg CF =0;    //carryFlag
 reg ZF =0;    //carryFlag
 reg CLK =0;   //clock
 reg Reset_in =0;
 
 wire  Reset_out;
 wire [3:0] Current_state_test;
 wire ALU_MUX;
 wire [3:0] ALU_OP;
 wire PC_INC;
 wire PC_LOAD;
 wire IR_WR_CLK;
 wire RAM_WR;
 wire RAM_RD;
 wire FLAG_WR_CLK;
 wire RAM_MUX;
 wire MDR_WR_CLK;
 wire A_WR_CLK;
 wire ALU_EN;
 Controller uut(
 .opCode(opCode),
 .D(D),
 .CF(CF),
 .ZF(ZF),
 .CLK(CLK),
 .Reset_in(Reset_in),
 .Reset_out(Reset_out),
 .Current_state_test(Current_state_test),
 .ALU_MUX(ALU_MUX),
 .ALU_OP(ALU_OP),
 .PC_INC(PC_INC),
 .PC_LOAD(PC_LOAD),
 .IR_WR_CLK(IR_WR_CLK),
 .RAM_WR(RAM_WR),
 .RAM_RD(RAM_RD),
 .FLAG_WR_CLK(FLAG_WR_CLK),
 .RAM_MUX(RAM_MUX),
 .MDR_WR_CLK(MDR_WR_CLK),
 .A_WR_CLK(A_WR_CLK),
 .ALU_EN(ALU_EN)
 );
 
always
  begin
  CLK =0; 
  #5; 
  CLK=1;
  #5; 
  end

initial
  begin
  //////////////////////// GROUP A
  opCode = 5'b00000;//MOVLA
  D=0;
  #30;
  opCode = 5'b00111;//MOVLA
  D=0;
  #30;
  opCode = 5'b01000;//MOVLA
  D=0;
  #30;
  opCode = 5'b01101;//MOVLA
  D=0;
  #30;
  opCode = 5'b01111;//MOVLA
  D=0;
  #30;
  
  
  //////////////////////// GROUP B
//  opCode = 5'b00010;//MOVAR
//  D=1;
//  #30;
//  //////////////////////// GROUP C
//  opCode = 5'b10110;//JZ
//  ZF=1;
//  #30;
//  opCode = 5'b10110;//JZ
//  ZF=0;
//  #20;             ////////
//  //////////////////////// GROUP D
//  opCode = 5'b00011;//MOVIRA
//  D=0;
//  #40;
//  //////////////////////// GROUP E
//  opCode = 5'b00100;//MOVIAR
//  D=1;
//  #50;
  end
endmodule
