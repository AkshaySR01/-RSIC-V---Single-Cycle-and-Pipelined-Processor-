`include "Data_Memory.v"

module Memory_Cycle(
    input clk,rst,
    input RegWriteM,
    input MemWriteM,
    input [1:0] ResultSrcM,
    input [31:0] ALUResultM,
    input [31:0] WriteDataM,
    input [4:0] RDM,
    input [31:0] PCPlus4M,

    output RegWriteW,
    output [1:0] ResultSrcW,
    output [31:0] ALUResultW,
    output [31:0] ReadDataW,
    output [4:0] RDW,
    output [31:0] PCPlus4W 
);
//Internal Wire
wire [31:0] ReadDataM;

reg RegWriteM_reg;
reg [1:0] ResultSrcM_reg;
reg [31:0] ALUResultM_reg;
reg [31:0] ReadDataM_reg,PCPlus4M_reg;
reg [4:0] RDM_reg;


Data_Memory Data_Memory(
     .clk(clk),
     .rst(rst),
     .WE(MemWriteM),
     .A(ALUResultM),
     .WriteData(WriteDataM),
     .ReadData(ReadDataM)
);

always @(posedge clk or negedge rst) begin

    if(rst==1'b0) begin
        RegWriteM_reg <= 1'b0;
        ResultSrcM_reg <= 2'b00;
        ALUResultM_reg <= 32'h00000000;
        ReadDataM_reg <= 32'h00000000;
        RDM_reg <= 5'b00000;
        PCPlus4M_reg <= 32'h00000000;
    end
    
    else begin
        RegWriteM_reg <= RegWriteM;
        ResultSrcM_reg <= ResultSrcM;
        ALUResultM_reg <= ALUResultM;
        ReadDataM_reg <= ReadDataM;
        RDM_reg <= RDM;
        PCPlus4M_reg <= PCPlus4M;
    end
end
    assign RegWriteW = RegWriteM_reg;
    assign ResultSrcW = ResultSrcM_reg;
    assign ALUResultW = ALUResultM_reg;
    assign ReadDataW = ReadDataM_reg;
    assign RDW = RDM_reg;
    assign PCPlus4W = PCPlus4M_reg;

endmodule