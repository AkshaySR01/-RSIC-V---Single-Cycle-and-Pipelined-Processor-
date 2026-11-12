`include "ALU.v"
`include "PC_Target.v"
`include "HazardMux.v"

module Execute_Cycle(
    input clk,rst,
    input RegWriteE,MemWriteE,JumpE,BranchE,ALUSrcE,
    input [3:0] ALUcontrolE,
    input [1:0] ResultSrcE,
    input [31:0] RD1_E,
    input [31:0] RD2_E,
    input [31:0] PCE,
    input [4:0] RDE,
    input [31:0] ImmExtE,
    input [31:0] PCPlus4E,
    input [31:0] ResultW,
    input [1:0] ForwardAE, ForwardBE,

    output PCSrcE,
    output [31:0] PCTargetE,
    output RegWriteM,
    output MemWriteM,
    output [1:0] ResultSrcM,
    output [31:0] ALUResultM,
    output [31:0] WriteDataM,
    output [4:0] RDM,
    output [31:0] PCPlus4M
);

//Internal Wires
wire [31:0] SrcAE,SrcBE,SrcBE_Interim;
wire [31:0] ALUResultE;
wire ZeroE;
wire PCSrcE;


//ALU Src Mux
assign SrcBE = ALUSrcE ? ImmExtE : SrcBE_Interim;

//PCSrc Fetch Cycle Functionality
assign PCSrcE = ( ZeroE & BranchE ) | JumpE;

//Declaration For Register
reg RegWriteE_reg,MemWriteE_reg;
reg [1:0] ResultSrcE_reg;
reg [31:0] ALUResultE_reg,WriteDataE_reg;
reg [4:0] RDE_reg;
reg [31:0] PCPlus4E_reg;

mux3_by_1 srca_mux(
    .a(RD1_E),
    .b(ResultW),
    .c(ALUResultM),
    .s(ForwardAE),
    .d(SrcAE)
);

mux3_by_1 srcb_mux(
    .a(RD2_E),
    .b(ResultW),
    .c(ALUResultM),
    .s(ForwardBE),
    .d(SrcBE_Interim)
);

alu alu(
    .A(SrcAE),
    .B(SrcBE),
    .alu_control(ALUcontrolE),
    .alu_result(ALUResultE),
    .Z_Flag(ZeroE)
);

PC_Target PC_Target(
     .PC(PCE),
     .ImmExt(ImmExtE),
     .PCTarget(PCTargetE)
    );

always @(posedge clk or negedge rst)begin

    if(rst==1'b0) begin
        RegWriteE_reg <=1'b0;
        MemWriteE_reg <=1'b0;
        ResultSrcE_reg <=2'b00;
        ALUResultE_reg <=32'h00000000;
        WriteDataE_reg <=32'h00000000;
        RDE_reg <=5'b00000;
        PCPlus4E_reg <=32'h00000000;
    end

    else begin
        RegWriteE_reg <=RegWriteE;
        MemWriteE_reg <=MemWriteE;
        ResultSrcE_reg <=ResultSrcE;
        ALUResultE_reg <=ALUResultE;
        WriteDataE_reg <=SrcBE_Interim;
        RDE_reg <=RDE;
        PCPlus4E_reg <=PCPlus4E;
    end
end
  //Assigning Output Signal values
    assign RegWriteM = RegWriteE_reg;
    assign MemWriteM = MemWriteE_reg;
    assign ResultSrcM = ResultSrcE_reg;
    assign ALUResultM = ALUResultE_reg;
    assign WriteDataM = WriteDataE_reg;
    assign RDM = RDE_reg;
    assign PCPlus4M = PCPlus4E_reg;
endmodule