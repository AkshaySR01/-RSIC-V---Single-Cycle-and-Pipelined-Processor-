`include "PC.v"
`include "Instruction_Memory.v"
`include "Register_File.v"
`include "Sign_Extend.v"
`include "ALU.v"
`include "Control_Unit.v"
`include "Data_Memory.v"
`include "PC_plus4.v"
`include "PC_Target.v"
`include "PC_Mux.v"

module Single_Cycle_Top(
    input clk,rst);

//-Program Counter Internal Wires-
wire [31:0] PC_DP;               //Program Counter Wire
wire [31:0] PC_Plus4_DP;         //PC plus4 Module o/p wire
wire [31:0] PC_Target_DP;        //PC target module o/p wire
wire [31:0] PC_Next_DP;

//------Register File Wires-------
wire [31:0] RD1_DP,RD2_DP;     //Register File RD1&RD2 Wire

//------Control Unit Wires--------
wire [1:0] ResultSrc_DP;
wire [3:0] ALU_Control_DP;
wire [2:0] ImmSrc_DP;
wire RegWrite_DP,MemWrite_DP;
wire ALUSrc_DP;                  //ALU Control Src wire 
wire PCSrc_DP;

//--------------------------------
wire [31:0] RD_Inst_DP;          //Instruction Memory Read Wire {Having Instruction}
wire [31:0] ALU_B_DP;                //ALU rs2 input wire
wire [31:0] ALU_Result_DP;
wire Zero_DP;

wire [31:0] ImmExt_DP;           //SignExtender Block Wire o/p
wire [31:0] ReadData_DP;         //Data Mewmory Output Wire
wire [31:0] Result_DP;           //Final Result Wire



//---ALU_Src Mux for ALU I/P--------------
assign ALU_B_DP=ALUSrc_DP ? ImmExt_DP : RD2_DP;

//---Result_Src Mux for result O/P--------
assign Result_DP = (ResultSrc_DP == 2'b00) ? ALU_Result_DP :
                   (ResultSrc_DP == 2'b01) ? ReadData_DP :
                   (ResultSrc_DP == 2'b10) ? PC_Plus4_DP :
                      32'b0;


   PC_Module PC(
       .clk(clk),
       .rst(rst),
       .PC(PC_DP),
       .PCNext(PC_Next_DP)
   );

   Instruction_Mem Instruction_Mem(
            .rst(rst),
            .A(PC_DP),
            .RD(RD_Inst_DP)
   );

   RegisterFile Register_File(
            .clk(clk),
            .rst(rst),
            .WE3(RegWrite_DP),
            .WD3(Result_DP),
            .A1(RD_Inst_DP[19:15]),
            .A2(RD_Inst_DP[24:20]),
            .A3(RD_Inst_DP[11:7]),
            .RD1(RD1_DP),
            .RD2(RD2_DP)
   );

   Sign_Extend Sign_Extend(
            .Instr(RD_Inst_DP),
            .ImmExt(ImmExt_DP),
            .ImmSrc(ImmSrc_DP)
   );

    alu alu(
        .A(RD1_DP),
        .B(ALU_B_DP),
        .alu_control(ALU_Control_DP),
        .alu_result(ALU_Result_DP),
        .Z_Flag(Zero_DP)
    );

    Control_Unit Control_Unit(
         .OP(RD_Inst_DP[6:0]), 
         .func3(RD_Inst_DP[14:12]),
         .func7(RD_Inst_DP[31:25]),
         .Zero(Zero_DP),
         .ALUcontrol(ALU_Control_DP),
         .ALUSrc(ALUSrc_DP),
         .ResultSrc(ResultSrc_DP), 
         .ImmSrc(ImmSrc_DP),
         .RegWrite(RegWrite_DP),
         .MemWrite(MemWrite_DP),
         .pcsrc(PCSrc_DP) 
    );

    Data_Memory Data_Memory(
         .clk(clk),
         .rst(rst),
         .WE(MemWrite_DP),
         .A(ALU_Result_DP),
         .WriteData(RD2_DP),
         .ReadData(ReadData_DP)
    );

    PC_plus4 PC_plus4(
         .PC(PC_DP),
         .PCPlus4(PC_Plus4_DP)
    );

    PC_Target PC_Target(
         .PC(PC_DP),
         .ImmExt(ImmExt_DP),
         .PCTarget(PC_Target_DP)
    );

    PC_Mux PC_Mux(
         .PCPlus4(PC_Plus4_DP),
         .PCTarget(PC_Target_DP),
         .PCSrc(PCSrc_DP),
         .PCNext(PC_Next_DP)
    );

endmodule