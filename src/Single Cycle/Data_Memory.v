module Data_Memory(
    input clk,WE,rst,
    input [31:0]A,WriteData,
    output [31:0] ReadData
);

reg [31:0] Data_Mem [1023:0];
//Read Functionality
assign ReadData=(WE==1'b0)? Data_Mem[A] :32'h0000_0000;
//Write Functionality
always @(posedge clk)
    begin
        if(WE)
        begin
            Data_Mem[A] <= WriteData;
        end
    end

initial 
 begin
    Data_Mem[0]=32'h00000020;
 end
endmodule