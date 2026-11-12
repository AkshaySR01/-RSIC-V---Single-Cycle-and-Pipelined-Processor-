`include "Control_Unit.v"
`include "Register_File.v"
`include "Sign_Extend.v"

module Decode_Cycle(
    input clk,rst,RegWriteW,
    input [31:0] InstrD,PCD,PCPlus4D,ResultW,
    input [4:0] RDW,
    output RegWriteE,
    output [1:0] ResultSrcE,
    output MemWriteE,
    output JumpE,
    output BranchE,
    output [3:0] ALUcontrolE,
    output ALUSrcE,
    output [31:0] RD1_E,
    output [31:0] RD2_E,
    input FlushE,

    output [4:0] RS1_E,RS2_E,
    output [31:0] PCE,
    output [4:0] RDE,
    output [31:0] ImmExtE,
    output [31:0] PCPlus4E
);

//Internal Wires
wire RegWriteD,ALUSrcD,MemWriteD,BranchD,JumpD;
wire [1:0] ResultSrcD,ALUopD;
wire [2:0] ImmSrcD;
wire [3:0] ALUcontrolD;
wire [31:0] RD1_D,RD2_D;
wire [31:0] ImmExtD;

//Declaration For Register
reg RegWriteD_reg,ALUSrcD_reg,MemWriteD_reg,BranchD_reg,JumpD_reg;
reg [1:0] ResultSrcD_reg;
reg [3:0] ALUcontrolD_reg;
reg [31:0] RD1_D_reg,RD2_D_reg,ImmExtD_reg;
reg [31:0] PCD_reg,PCPlus4D_reg;
reg [4:0] RDD_reg;
reg [4:0] RS1_D_reg,RS2_D_reg;

//Module Instantiation
main_Decoder Main_Decoder(
      .OP(InstrD[6:0]),
      .MemWrite(MemWriteD),
      .RegWrite(RegWriteD),
      .ALUSrc(ALUSrcD),
      .ALUop(ALUopD),
      .ImmSrc(ImmSrcD),
      .ResultSrc(ResultSrcD),
      .Branch(BranchD),
      .Jump(JumpD)
);

ALU_Decoder ALU_Decoder(
    .OP(InstrD[6:0]),
    .ALUop(ALUopD),
    .func3(InstrD[14:12]),
    .func7(InstrD[31:25]),
    .ALUcontrol(ALUcontrolD)
);

RegisterFile Register_File(
            .clk(clk),
            .rst(rst),
            .WE3(RegWriteW),
            .WD3(ResultW),
            .A1(InstrD[19:15]),
            .A2(InstrD[24:20]),
            .A3(RDW),
            .RD1(RD1_D),
            .RD2(RD2_D)
);

Sign_Extend Sign_Extend(
            .Instr(InstrD),
            .ImmExt(ImmExtD),
            .ImmSrc(ImmSrcD)
);

always @(posedge clk or negedge rst) begin

        if(rst == 1'b0) begin
        RegWriteD_reg <= 1'b0;
        ALUSrcD_reg <= 1'b0;
        MemWriteD_reg <= 1'b0;
        BranchD_reg <= 1'b0;
        JumpD_reg <= 1'b0;

        ResultSrcD_reg <= 2'b00;
        ALUcontrolD_reg <= 4'b0000;
        RD1_D_reg <= 32'h00000000;
        RD2_D_reg <= 32'h00000000;
        ImmExtD_reg <= 32'h00000000;
        PCD_reg <= 32'h00000000;
        PCPlus4D_reg <= 32'h00000000;
        RDD_reg <= 5'b00000;
        RS1_D_reg <= 5'b00000;
        RS2_D_reg <= 5'b00000;

    end

        else if (FlushE) begin
        RegWriteD_reg <= 1'b0;
        ALUSrcD_reg <= 1'b0;
        MemWriteD_reg <= 1'b0;
        BranchD_reg <= 1'b0;
        JumpD_reg <= 1'b0;

        ResultSrcD_reg <= 2'b00;
        ALUcontrolD_reg <= 4'b0000;
        RD1_D_reg <= 32'h00000000;
        RD2_D_reg <= 32'h00000000;
        ImmExtD_reg <= 32'h00000000;
        PCD_reg <= 32'h00000000;
        PCPlus4D_reg <= 32'h00000000;
        RDD_reg <= 5'b00000;
        RS1_D_reg <= 5'b00000;
        RS2_D_reg <= 5'b00000;
        end

        else begin
        RegWriteD_reg <= RegWriteD;
        ALUSrcD_reg <= ALUSrcD;
        MemWriteD_reg <= MemWriteD;
        BranchD_reg <= BranchD;
        JumpD_reg <= JumpD;

        ResultSrcD_reg <= ResultSrcD;
        ALUcontrolD_reg <= ALUcontrolD;
        RD1_D_reg <= RD1_D;
        RD2_D_reg <= RD2_D;
        ImmExtD_reg <= ImmExtD;
        PCD_reg <= PCD;
        PCPlus4D_reg <= PCPlus4D;
        RDD_reg <= InstrD[11:7];
        RS1_D_reg <= InstrD[19:15];
        RS2_D_reg <= InstrD[24:20];
        end
    end

    //Assigning Register Value for Execute Stage
        assign RegWriteE =RegWriteD_reg;
        assign ResultSrcE =ResultSrcD_reg;
        assign MemWriteE=MemWriteD_reg;
        assign JumpE =JumpD_reg;
        assign BranchE =BranchD_reg;
        assign ALUcontrolE =ALUcontrolD_reg;
        assign ALUSrcE =ALUSrcD_reg;
        assign RD1_E =RD1_D_reg;
        assign RD2_E =RD2_D_reg;
        assign PCE =PCD_reg;
        assign RDE =RDD_reg;
        assign ImmExtE =ImmExtD_reg;
        assign PCPlus4E =PCPlus4D_reg;
        assign RS1_E=RS1_D_reg;
        assign RS2_E=RS2_D_reg;

endmodule