`include "Fetch_Cycle.v"
`include "Decode_Cycle.v"
`include "Execute_Cycle.v"
`include "Memory_Cycle.v"
`include "WriteBack_Cycle.v"
`include "Forward_Hazard.v"
`include "Load_Hazard.v"


module Pipeline_Top(
    input clk,rst
);
wire PCSrcE,RegWriteM,RegWriteW,RegWriteE,MemWriteE,MemWriteM,BranchE,ALUSrcE,JumpE;
wire [31:0] PCTargetE,InstrD,PCD,ResultW,RD1_E,RD2_E,PCE;
wire [31:0] ImmExtE,PCPlus4D,PCPlus4E,PCPlus4M,PCPlus4W,ALUResultM,WriteDataM,ALUResultW;
wire [31:0] ReadDataW;
wire [4:0] RDW,RDM;
wire [1:0] ResultSrcE,ResultSrcM,ResultSrcW;
wire [3:0] ALUcontrolE;
wire [4:0] RDE;
wire [6:0] OpcodeD;
wire StallD,FlushE,StallF;
wire [4:0] RS1_D, RS2_D;
wire UseRs1D, UseRs2D;

wire MemReadE;
wire [4:0] RS1_E, RS2_E;
wire [1:0] ForwardAE,ForwardBE;

assign OpcodeD = InstrD[6:0];
assign RS1_D = InstrD[19:15];
assign RS2_D = InstrD[24:20];
assign MemReadE = (ResultSrcE == 2'b01);


assign UseRs1D =
    (OpcodeD == 7'b0110011) ||  // R-type
    (OpcodeD == 7'b0010011) ||  // I-type arithmetic
    (OpcodeD == 7'b0000011) ||  // Load
    (OpcodeD == 7'b0100011) ||  // Store
    (OpcodeD == 7'b1100011) ||  // Branch
    (OpcodeD == 7'b1100111);    // JALR

assign UseRs2D =
    (OpcodeD == 7'b0110011) ||  // R-type
    (OpcodeD == 7'b0100011) ||  // Store
    (OpcodeD == 7'b1100011);    // Branch
//----------Fetch_Cycle--------------
Fetch_Cycle Fetch_Cycle(
        .clk(clk),
        .rst(rst),
        .PCSrcE(PCSrcE),
        .StallD(StallD),
        .StallF(StallF),
        .PCTargetE(PCTargetE),
        .InstrD(InstrD),
        .PCD(PCD),
        .PCPlus4D(PCPlus4D)
);

//----------Decode_Cycle-------------
Decode_Cycle Decode_Cycle(
        .clk(clk),
        .rst(rst),
        .RegWriteW(RegWriteW),
        .InstrD(InstrD),
        .PCD(PCD),
        .PCPlus4D(PCPlus4D),
        .ResultW(ResultW),
        .RDW(RDW),
        .RegWriteE(RegWriteE),
        .ResultSrcE(ResultSrcE),
        .MemWriteE(MemWriteE),
        .JumpE(JumpE),
        .BranchE(BranchE),
        .ALUcontrolE(ALUcontrolE),
        .ALUSrcE(ALUSrcE),
        .FlushE(FlushE),
        .RD1_E(RD1_E),
        .RD2_E(RD2_E),
        .PCE(PCE),
        .RDE(RDE),
        .ImmExtE(ImmExtE),
        .PCPlus4E(PCPlus4E),
        .RS1_E(RS1_E),
        .RS2_E(RS2_E)
);

//----------Execute_Cycle------------
Execute_Cycle Execute_Cycle(
        .clk(clk),
        .rst(rst),
        .RegWriteE(RegWriteE),
        .MemWriteE(MemWriteE),
        .JumpE(JumpE),
        .BranchE(BranchE),
        .ALUSrcE(ALUSrcE),
        .ALUcontrolE(ALUcontrolE),
        .ResultSrcE(ResultSrcE),
        .RD1_E(RD1_E),
        .RD2_E(RD2_E),
        .PCE(PCE),
        .RDE(RDE),
        .ImmExtE(ImmExtE),
        .PCPlus4E(PCPlus4E),
        .ResultW(ResultW),
        .ForwardAE(ForwardAE),
        .ForwardBE(ForwardBE),

        .PCSrcE(PCSrcE),
        .PCTargetE(PCTargetE),
        .RegWriteM(RegWriteM),
        .MemWriteM(MemWriteM),
        .ResultSrcM(ResultSrcM),
        .ALUResultM(ALUResultM),
        .WriteDataM(WriteDataM),
        .RDM(RDM),
        .PCPlus4M(PCPlus4M)
);

//----------Memory_Cycle-------------
Memory_Cycle Memory_Cycle(
        .clk(clk),
        .rst(rst),
        .RegWriteM(RegWriteM),
        .MemWriteM(MemWriteM),
        .ResultSrcM(ResultSrcM),
        .ALUResultM(ALUResultM),
        .WriteDataM(WriteDataM),
        .RDM(RDM),
        .PCPlus4M(PCPlus4M),

        .RegWriteW(RegWriteW),
        .ResultSrcW(ResultSrcW),
        .ALUResultW(ALUResultW),
        .ReadDataW(ReadDataW),
        .RDW(RDW),
        .PCPlus4W(PCPlus4W)
);

//----------WriteBack_Cycle----------
WriteBack_Cycle WriteBack_Cycle(
        .clk(clk),
        .rst(rst),
        .ResultSrcW(ResultSrcW),
        .ALUResultW(ALUResultW),
        .ReadDataW(ReadDataW),
        .PCPlus4W(PCPlus4W),

        .ResultW(ResultW)
);

//---------Hazard Unit---------------
Forward_Hazard Forward_Hazard(
        .rst(rst),
        .RegWriteM(RegWriteM),
        .RegWriteW(RegWriteW),
        .RDM(RDM),
        .RDW(RDW),
        .RS1_E(RS1_E),
        .RS2_E(RS2_E),
        .ForwardAE(ForwardAE),
        .ForwardBE(ForwardBE)
);

Load_Hazard Load_Hazard(
        .MemReadE(MemReadE),
        .RDE(RDE),
        .RS1_D(RS1_D),
        .RS2_D(RS2_D),
        .UseRs1D(UseRs1D),
        .UseRs2D(UseRs2D),
        .StallF(StallF),
        .StallD(StallD),
        .FlushE(FlushE)
);
endmodule