`include "PC.v"
`include "PC_Mux.v"
`include "PC_plus4.v"
`include "Instruction_Memory.v"

module Fetch_Cycle(
    input clk,
    input rst,
    input PCSrcE,
    input StallD,
    input StallF,

    input [31:0] PCTargetE,
    output [31:0] InstrD,
    output [31:0] PCD,
    output [31:0] PCPlus4D
);
//Insternal Wires
wire [31:0] PCNextF;
wire [31:0] PCF;
wire [31:0] PCPlus4F;
wire [31:0] InstrF;

//Declaration For Register
reg [31:0] InstrF_reg;
reg [31:0] PCF_reg,PCPlus4F_reg;

//Instantiating Modules
//PC MUX
PC_Mux PC_Mux(
        .PCPlus4(PCPlus4F),
        .PCTarget(PCTargetE),
        .PCSrc(PCSrcE),
        .PCNext(PCNextF)
);
//Program Counter
PC_Module PC_Module(
        .clk(clk),
        .rst(rst),
        .StallF(StallF),
        .PCNext(PCNextF),
        .PC(PCF)
);

Instruction_Mem Instruction_Mem(
        .rst(rst),
        .A(PCF),
        .RD(InstrF)
);

PC_plus4 PC_plus4(
        .PC(PCF),
        .PCPlus4(PCPlus4F)
);
//Fetch Cycle Register
always @(posedge clk or negedge rst) begin

    if(rst==1'b0)begin
        InstrF_reg<=32'h00000000;
        PCF_reg<=32'h00000000;
        PCPlus4F_reg<=32'h00000000;
    end

    else if (!StallD) begin
        InstrF_reg<=InstrF;
        PCF_reg<=PCF;
        PCPlus4F_reg<=PCPlus4F;
    end
end

//Assigning Register Values
assign InstrD=(rst==1'b0) ? 32'h00000000 : InstrF_reg;
assign PCD=(rst==1'b0) ? 32'h00000000 : PCF_reg;
assign PCPlus4D=(rst==1'b0) ? 32'h00000000 : PCPlus4F_reg;

endmodule