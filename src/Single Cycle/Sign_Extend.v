module Sign_Extend(
    input [31:0] Instr,        //32 Bit Instruction i/p from instruction memory
    input [2:0] ImmSrc,        //2 BIt SignExtent select{FRom control unit}
    output reg [31:0] ImmExt
);

/*ImmSrc From ControlUnit is used to sign extent the different 
  types of instruction and the respective Immediate BIt Location*/
always@(*)begin
    case(ImmSrc)
    //I-Type Instruction
    3'b000:ImmExt= {{20{Instr[31]}},Instr[31:20]};
    //S-Type
    3'b001:ImmExt= {{20{Instr[31]}},Instr[31:25],Instr[11:7]};
    //B-Type
    3'b010:ImmExt= {{19{Instr[31]}},Instr[31],Instr[7],Instr[30:25],Instr[11:8],1'b0};
    //J-Type
    3'b100:ImmExt= {{11{Instr[31]}},Instr[31],Instr[19:12],Instr[20],Instr[30:21],1'b0};

    // Invalid immediate format
    default: ImmExt = 32'b0;
    endcase
end
endmodule