`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 09/28/2022 05:02:33 PM
// Design Name: 
// Module Name: Controller
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: by Momen Odeh & Noor Aldeen Abu Shehadeh
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module Controller(
 input [4:0]opCode,
 input D,     //destination
 input CF,    //carryFlag
 input ZF,    //carryFlag
 input CLK,   //clock
 input Reset_in,
 
 output reg  Reset_out,
 output reg [3:0] Current_state_test,
 output reg ALU_MUX,
 output reg [3:0] ALU_OP,
 output reg PC_INC,
 output reg PC_LOAD,
 output reg IR_WR_CLK,
 output reg RAM_WR,
 output reg RAM_RD,
 output reg FLAG_WR_CLK,
 output reg RAM_MUX,
 output reg MDR_WR_CLK,
 output reg A_WR_CLK,
 output reg ALU_EN
    );
 parameter S0 = 4'b0000, S1 = 4'b0001, S2 = 4'b0010, S3 = 4'b0011, S4 = 4'b0100, S5 = 4'b0101,
  S6 = 4'b0110, S7 = 4'b0111, S8 = 4'b1000, S9 = 4'b1001;
  reg [3:0] Current_State=S0, Next_State=S0;
  reg IR_WR;
  reg MDR_WR;
  reg A_WR;
  reg FLAG_WR;
  //divider
  reg CLK2=0;
  integer i=0;
  //
  
  //Op-Code for instruction
  parameter 
  //Group A
  MOVLA = 5'b00000,
  MOVRA = 5'b00001,
  ADDLA = 5'b00111,
  SUBLA = 5'b01000,
  ANDLA = 5'b01011,
  ORLA = 5'b01101,
  XORLA = 5'b01111,
  //Group A&B
  ADDAR = 5'b01001,
  SUBAR = 5'b01010,
  ANDAR = 5'b01100,
  ORAR = 5'b01110,
  XORAR = 5'b10000,
  //Group B
  MOVAR = 5'b00010,
  INCR = 5'b00101,
  DECR = 5'b00110,
  NOTR = 5'b10001,
  ROLC = 5'b10010,
  RORC = 5'b10011,
  //Group C
  JMP = 5'b10101,
  JZ = 5'b10110,
  JNZ = 5'b10111,
  JC = 5'b11000,
  JNC = 5'b11001,
  //Group D
  MOVIRA = 5'b00011,
  //Group E
  MOVIAR = 5'b00100 ;
  
  always @(opCode)
  begin
  case(opCode)
  //Group A
  MOVLA:  begin ALU_OP = 4'b1000 ; ALU_MUX = 0; end
  MOVRA:  begin ALU_OP = 4'b1000 ; ALU_MUX = 1; end          
  ADDLA:  begin ALU_OP = 4'b0000 ; ALU_MUX = 0; end
  SUBLA:  begin ALU_OP = 4'b0001 ; ALU_MUX = 0; end
  ANDLA:  begin ALU_OP = 4'b0100 ; ALU_MUX = 0; end
  ORLA:   begin ALU_OP = 4'b0101 ; ALU_MUX = 0; end
  XORLA:  begin ALU_OP = 4'b0110 ; ALU_MUX = 0; end
  //Group A&B
  ADDAR:  begin ALU_OP = 4'b0000 ; ALU_MUX = 1; end
  SUBAR:  begin ALU_OP = 4'b0001 ; ALU_MUX = 1; end
  ANDAR:  begin ALU_OP = 4'b0100 ; ALU_MUX = 1; end
  ORAR:   begin ALU_OP = 4'b0101 ; ALU_MUX = 1; end
  XORAR:  begin ALU_OP = 4'b0110 ; ALU_MUX = 1; end
  //Group B
  MOVAR:  begin ALU_OP = 4'b1001 ; ALU_MUX = 1; end
  INCR:   begin ALU_OP = 4'b0010 ; ALU_MUX = 1; end
  DECR:   begin ALU_OP = 4'b0011 ; ALU_MUX = 1; end
  NOTR:   begin ALU_OP = 4'b0111 ; ALU_MUX = 1; end
  ROLC:   begin ALU_OP = 4'b1010 ; ALU_MUX = 1; end
  RORC:   begin ALU_OP = 4'b1011 ; ALU_MUX = 1; end
  //Group C
  JMP:   begin ALU_OP = 4'b0000 ; ALU_MUX = 0; end
  JZ:    begin ALU_OP = 4'b0000 ; ALU_MUX = 0; end
  JNZ:   begin ALU_OP = 4'b0000 ; ALU_MUX = 0; end
  JC:    begin ALU_OP = 4'b0000 ; ALU_MUX = 0; end
  JNC:   begin ALU_OP = 4'b0000 ; ALU_MUX = 0; end
  //Group D
  MOVIRA:    begin ALU_OP = 4'b1000 ; ALU_MUX = 1; end
  //Group E
  MOVIAR:    begin ALU_OP = 4'b1001 ; ALU_MUX = 1; end
  
  default :  begin ALU_OP = 4'b0000 ; ALU_MUX = 0; end
  endcase
  end
  
  always @(*)
  begin
    IR_WR_CLK = IR_WR && CLK2;
    MDR_WR_CLK = MDR_WR && CLK2;
    A_WR_CLK = A_WR && CLK2;
    FLAG_WR_CLK = FLAG_WR && CLK2;
  end
  ///////////////////////////////////////////////////////////////
  //clk divider here 50 MHz --> 1Hz
  always @(negedge CLK)
  begin
    if(i < 50000000)
        begin
        i=i+1;
        end
    else
        begin
        i=0;
        CLK2=~CLK2;
        end
  end
  //
  always @(negedge CLK2,posedge Reset_in) //for CuttentState
  begin
   if (Reset_in == 1) // Active High RESET
    begin
        Current_State = S0; 
        Reset_out = 1;
    end
    else 
    begin
        Current_State = Next_State;
        Reset_out = 0;
    end 
  end
  ///////////////////////////////////////////////////////////////
  always @ (Current_State) // for Output and NextState
  begin 
    case(Current_State)
    S0:
        begin
        Current_state_test = 4'b0000;
        IR_WR = 1;
        RAM_RD = 1;
        RAM_WR = 1;
        MDR_WR = 0;
        ALU_EN = 0;
        A_WR = 0;
        PC_INC = 0;
        PC_LOAD	= 1;
        RAM_MUX = 0;
        FLAG_WR = 0;			
        Next_State = S1;
        end
    S1:
    begin
        Current_state_test = 4'b0001;
        IR_WR = 0;
        RAM_RD = 0;
        RAM_WR = 1;
        MDR_WR = 1;
        ALU_EN = 1;
        A_WR = 0;
        PC_INC = 1;
        PC_LOAD	= 1;
        RAM_MUX = 0;
        FLAG_WR = 0;
        case(opCode)
        //Group A
        MOVLA , MOVRA , ADDLA , SUBLA , ANDLA , ORLA , XORLA :
           Next_State= S2;
        //Group A&B
        ADDAR , SUBAR , ANDAR , ORAR , XORAR :
            if (D == 0) 
                Next_State = S2;						
            else
                Next_State = S3;
        //Group B
        MOVAR , INCR , DECR , NOTR , ROLC , RORC:
            Next_State = S3;
        //Group C
        JMP :
            Next_State = S4;
        JZ :
            if(ZF == 0)
                Next_State = S0;
            else
                Next_State = S4;
        JNZ :
            if(ZF== 0)
                Next_State = S4;
            else
                Next_State = S0;
        JC :
            if(CF == 0)
                Next_State = S0;
            else
                Next_State = S4;
        JNC :
            if(CF == 0)
                Next_State = S4;
            else
                Next_State = S0;
        //Group D
        MOVIRA:
            Next_State = S5;
        //Group E
        MOVIAR:
            Next_State = S7;
        default:
            Next_State = S0;                           
        endcase
    end
    S2:
    begin
        Current_state_test = 4'b0010;
        IR_WR = 0;
        RAM_RD = 1;
        RAM_WR = 1;
        MDR_WR = 0;
        ALU_EN = 0;
        A_WR = 1;
        PC_INC = 0;
        PC_LOAD	= 1;
        RAM_MUX = 0;
        FLAG_WR = 1;
        Next_State = S0;
    end
    S3:
    begin
        Current_state_test = 4'b0011;
        IR_WR = 0;
        RAM_RD = 1;
        RAM_WR = 0;
        MDR_WR = 0;
        ALU_EN = 0;
        A_WR = 0;
        PC_INC = 0;
        PC_LOAD	= 1;
        RAM_MUX = 0;
        FLAG_WR = 1;
        Next_State = S0;
    end
    S4:
    begin
        Current_state_test = 4'b0100;
        IR_WR = 0;
        RAM_RD = 1;
        RAM_WR = 1;
        MDR_WR = 0;
        ALU_EN = 0;
        A_WR = 0;
        PC_INC = 0;
        PC_LOAD	= 0;
        RAM_MUX = 0;
        FLAG_WR = 0;
        Next_State = S0;
    end
    S5:
    begin
        Current_state_test = 4'b0101;
        IR_WR = 0;
        RAM_RD = 0;
        RAM_WR = 1;
        MDR_WR = 1;
        ALU_EN = 1;
        A_WR = 0;
        PC_INC = 0;
        PC_LOAD	= 1;
        RAM_MUX = 1;
        FLAG_WR = 0;
        Next_State = S6;
    end
    S6:
    begin
        Current_state_test = 4'b0110;
        IR_WR = 0;
        RAM_RD = 1;
        RAM_WR = 1;
        MDR_WR = 0;
        ALU_EN = 0;
        A_WR = 1;
        PC_INC = 0;
        PC_LOAD	= 1;
        RAM_MUX = 1;
        FLAG_WR = 1;
        Next_State = S0;
    end
    S7:
    begin
        Current_state_test = 4'b0111;
        IR_WR = 0;
        RAM_RD = 1;
        RAM_WR = 1;
        MDR_WR = 0;
        ALU_EN = 0;
        A_WR = 0;
        PC_INC = 0;
        PC_LOAD	= 1;
        RAM_MUX = 1;
        FLAG_WR = 0;
        Next_State = S8;
    end
    S8:
    begin
        Current_state_test = 4'b1000;
        IR_WR = 0;
        RAM_RD = 1;
        RAM_WR = 0;
        MDR_WR = 0;
        ALU_EN = 0;
        A_WR = 0;
        PC_INC = 0;
        PC_LOAD	= 1;
        RAM_MUX = 1;
        FLAG_WR = 0;
        Next_State = S9;
    end
    S9:
    begin
        Current_state_test = 4'b1001;
        IR_WR = 0;
        RAM_RD = 1;
        RAM_WR = 1;
        MDR_WR = 0;
        ALU_EN = 0;
        A_WR = 0;
        PC_INC = 0;
        PC_LOAD	= 1;
        RAM_MUX = 1;
        FLAG_WR = 0;
        Next_State = S0;
    end
    endcase
  end
  
 
endmodule
