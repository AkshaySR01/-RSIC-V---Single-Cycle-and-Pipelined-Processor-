module Instruction_Mem(
    input [31:0]A,
    input rst,
    output [31:0] RD 
);
//Instruction Memory
 reg [31:0] Mem [1023:0];

 assign RD=(rst==1'b0)?32'h0000_0000 : Mem[A[31:2]];

initial
    begin
    $readmemh("memfile.hex",Mem);
    end 
endmodule