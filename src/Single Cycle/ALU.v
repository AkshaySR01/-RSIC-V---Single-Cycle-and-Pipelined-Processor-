// module alu(A,B,ALUcontrol,Results,N_Flag,Z_Flag,V_Flag,C_Flag);
// //Declaring inputs
// input [31:0] A,B;
// input [2:0] ALUcontrol;
// //Declaring output
// output [31:0] Results;
// output N,Z,V,C:

// //Declaring wires
// wire [31:0] a_and_b;
// wire [31:0] a_or_b;
// wire [31:0] not_b;

// wire [31:0] mux_1;
// wire [31:0] mux_2;

// wire [31:0] sum;
// wire cout;

// //Logic design
// assign a_and_b=A & B;
// assign a_or_b=A ^ B;
// assign not_b= ~B;

// //Mux_1
// assign mux_1= (ALUcontrol[0]== 1'b0) ? B:not_b;

// //Mux_2
// assign mux_2= (ALUcontrol[1:0]==2'b00) ? sum :
//               (ALUcontrol[1:0]==2'b01) ? sum :
//               (ALUcontrol[1:0]==2'b10) ? a_and_b : a_or_b;

// assign {cout,sum}=A+ mux_1+ALUcontrol[0];

// //Flag assignment
// assign Z_flag= ~|Results;   // Zero_Flag
// assign N_Flag= Results[31]; // Sign_Flag 

// assign C_Flag= cout & (~ALUcontrol[1])  //Carry_Flag
// assign V_Flag=(~ALUcontrol[1]) & (A[31]^sum[31]) & (A[31]^B[31]^ALUcontrol[0]); //Overflow_Flag

// assign Results=mux_2;
// endmodule

module alu(
    input wire [31:0] A,
    input wire [31:0] B,
    input wire [3:0] alu_control,        // ALU Operation Selection
    output reg [31:0] alu_result,        // ALU Result
    output Z_Flag
);

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

    reg [32:0] ext_result;

always@(*) 
  begin
    case(alu_control)
    ALU_ADD :alu_result =  A + B;
    ALU_SUB :alu_result =  A - B;
    ALU_AND :alu_result =  A & B;
    ALU_OR  :alu_result =  A | B;
    ALU_XOR :alu_result =  A ^ B;
    ALU_SLL :alu_result =  A << B[4:0];
    ALU_SRL :alu_result =  A >> B[4:0];
    ALU_SRA :alu_result =  $signed(A) >>> B[4:0];
    ALU_SLT :alu_result = ($signed(A)<$signed(B))?32'd1:32'd0;
    ALU_SLTU:alu_result = (A < B) ? 32'd1 : 32'd0;
    default :alu_result = 32'd0;
    endcase
  end

//Zero_Flag
assign Z_Flag=(alu_result==32'd0);


endmodule