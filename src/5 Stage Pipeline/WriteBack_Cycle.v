module WriteBack_Cycle(
    input clk,rst,
    input [1:0] ResultSrcW,
    input [31:0] ALUResultW,
    input [31:0] ReadDataW,
    input [31:0] PCPlus4W,

    output [31:0] ResultW
);

//---Result_Src Mux for result O/P--------
assign ResultW = (ResultSrcW == 2'b00) ? ALUResultW :
                   (ResultSrcW == 2'b01) ? ReadDataW :
                   (ResultSrcW == 2'b10) ? PCPlus4W :
                      32'b0;

endmodule