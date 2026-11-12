module PC_Mux (
    input  wire [31:0] PCPlus4,
    input  wire [31:0] PCTarget,
    input  wire        PCSrc,
    output wire [31:0] PCNext
);

    assign PCNext = PCSrc ? PCTarget : PCPlus4;

endmodule
