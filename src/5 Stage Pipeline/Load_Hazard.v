module Load_Hazard(
    input MemReadE,
    input [4:0] RDE,
    input [4:0] RS1_D,
    input [4:0] RS2_D,
    input UseRs1D,
    input UseRs2D,

    output StallF,
    output StallD,
    output FlushE
);

wire LoadUseHazard;

assign LoadUseHazard =MemReadE && (RDE != 5'b00000) && ((UseRs1D && (RDE == RS1_D)) ||
                        (UseRs2D && (RDE == RS2_D)));

assign StallF = LoadUseHazard;
assign StallD = LoadUseHazard;
assign FlushE = LoadUseHazard;

endmodule