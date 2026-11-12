module Forward_Hazard(
    input rst,
    input RegWriteM,
    input RegWriteW,
    input [4:0] RDM,RDW,RS1_E,RS2_E,
    output [1:0] ForwardAE, ForwardBE
);

assign ForwardAE = (rst == 1'b0) ? 2'b00 : 
                       ((RegWriteM == 1'b1) & (RDM != 5'h00) & (RDM == RS1_E)) ? 2'b10 :
                       ((RegWriteW == 1'b1) & (RDW != 5'h00) & (RDW == RS1_E)) ? 2'b01 : 2'b00;
                       
assign ForwardBE = (rst == 1'b0) ? 2'b00 : 
                       ((RegWriteM == 1'b1) & (RDM != 5'h00) & (RDM == RS2_E)) ? 2'b10 :
                       ((RegWriteW == 1'b1) & (RDW != 5'h00) & (RDW == RS2_E)) ? 2'b01 : 2'b00;

endmodule