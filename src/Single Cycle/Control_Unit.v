module Control_Unit(
    input  wire [6:0] OP,          //Operation Code
    input  wire [2:0] func3,       //[14:12]-3 Bits
    input  wire [6:0] func7,       //[31:25]-7 Bits
    input  wire Zero,              //ALU Zero Flag O/p
    output wire [3:0] ALUcontrol,  //ALU Control
    output wire ALUSrc,            //ALU Src
    output wire [1:0] ResultSrc,   //Result Src
    output wire [2:0] ImmSrc,      //Immediate select for Sign Extend
    output wire RegWrite,          //Register Write
    output wire MemWrite,          //Memory Write
    output wire pcsrc              // PC source
);

wire Branch,Jump;
wire [1:0] ALUop;

//Instantiated Modules of Main & ALU Controller.
main_Decoder Main_Decoder(
      .OP(OP),
      .MemWrite(MemWrite),
      .RegWrite(RegWrite),
      .ALUSrc(ALUSrc),
      .ALUop(ALUop),
      .ImmSrc(ImmSrc),
      .ResultSrc(ResultSrc),
      .Branch(Branch),
      .Jump(Jump)
);

ALU_Decoder ALU_Decoder(
    .OP(OP),
    .ALUop(ALUop),
    .func3(func3),
    .func7(func7),
    .ALUcontrol(ALUcontrol)
);

assign pcsrc=Branch & Zero | Jump;
endmodule

//---------------Main_Decoder-------------------------
module main_Decoder(
    input [6:0] OP,
    output reg MemWrite,
    output reg RegWrite,
    output reg ALUSrc,
    output reg Branch,Jump,
    output reg [1:0] ALUop,
    output reg [2:0] ImmSrc,
    output reg [1:0] ResultSrc
);

always@(*)
  begin
    //defaults
        RegWrite    = 1'b0;
        MemWrite    = 1'b0;
        ALUSrc      = 1'b0;
        ResultSrc   = 2'b00;
        ImmSrc      = 3'b000;
        ALUop       = 2'b00;
        Branch      = 1'b0;
        Jump        = 1'b0;

  case(OP)
    // R-Type Instruction
    7'b0110011:begin
        RegWrite=1'b1;
        ALUop=2'b10;
    end

    //I-Type Instruction
    7'b0010011:begin
        RegWrite=1'b1;
        ImmSrc=3'b000;
        ALUSrc=1'b1;
        ALUop=2'b10;
    end

    //Load Instructions
    7'b0000011:begin
        RegWrite=1'b1;
        ImmSrc=3'b000;
        ALUSrc=1'b1;
        ALUop=2'b00;
        ResultSrc=2'b01;
    end

    //Store Instructions
    7'b0100011:begin
        MemWrite=1'b1;
        ImmSrc=3'b001;
        ALUSrc=1'b1;
        ALUop=2'b00;
    end

    //Branch Type
    7'b1100011:begin
        Branch = 1'b1;
        ALUSrc = 1'b0;
        ImmSrc = 3'b010;
        ALUop  = 2'b01;    
    end

    //JAL
    7'b1101111:begin
        RegWrite  = 1'b1;
        ResultSrc = 2'b10;
        ImmSrc    = 3'b100;
        Jump      = 1'b1;
        ALUop     = 2'b00;
    end
  endcase
  end 
endmodule

//----------------ALU_Decoder-------------------------
module ALU_Decoder(
    input [6:0] OP,
    input [1:0] ALUop,
    input [2:0] func3,
    input [6:0] func7,
    output reg [3:0] ALUcontrol
);

 //ALU Operations
    localparam ALU_ADD  = 4'b0000;
    localparam ALU_SUB  = 4'b0001;
    localparam ALU_AND  = 4'b0010;
    localparam ALU_OR   = 4'b0011;
    localparam ALU_XOR  = 4'b0100;
    localparam ALU_SLL  = 4'b0101; // Shift Left Logical
    localparam ALU_SRL  = 4'b0110; // Shift Right Logical
    localparam ALU_SRA  = 4'b0111; // Shift Right Arithmetic
    localparam ALU_SLT  = 4'b1000; // Set Less Than (Signed)
    localparam ALU_SLTU = 4'b1001; // Set Less Than (Unsigned)
 
 
always @(*)
 begin
    case(ALUop)
      //Operation That always require addition
      2'b00:ALUcontrol<=ALU_ADD;
      //Operation That always require Sub{Branched comparisons}
      2'b01:ALUcontrol<=ALU_SUB;
      
      //ALU Arithemetic/Logical Operation
      2'b10:begin
      case(OP)
      //R-Type Instructions
      7'b0110011:begin
      case(func3)
            3'b000:ALUcontrol<=((OP==7'b0110011)&&(func7==7'b0100000))?ALU_SUB:ALU_ADD;
            3'b001:ALUcontrol<=ALU_SLL;
            3'b010:ALUcontrol<=ALU_SLT;
            3'b011:ALUcontrol<=ALU_SLTU;
            3'b100:ALUcontrol<=ALU_XOR;
            3'b101:ALUcontrol<=((OP==7'b0110011)&&(func7==7'b0100000))?ALU_SRA:ALU_SRL;
            3'b110:ALUcontrol<=ALU_OR;
            3'b111:ALUcontrol<=ALU_AND;
            default:ALUcontrol<=4'bxxxx;
      endcase
      end
      
      //I-Type Instructions
      7'b0010011:begin
        case(func3)
            3'b000:ALUcontrol<=ALU_ADD;
            3'b001:ALUcontrol<=ALU_SLL;
            3'b010:ALUcontrol<=ALU_SLT;
            3'b011:ALUcontrol<=ALU_SLTU;
            3'b100:ALUcontrol<=ALU_XOR;
            3'b101:ALUcontrol<=((OP==7'b0010011)&&(func7==7'b0100000))?ALU_SRA:ALU_SRL;
            3'b110:ALUcontrol<=ALU_OR;
            3'b111:ALUcontrol<=ALU_AND;
            default:ALUcontrol<=4'bxxx;
        endcase
      end
    endcase
    end
    endcase
 end
endmodule