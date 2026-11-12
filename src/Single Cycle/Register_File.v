module RegisterFile(
    input clk,WE3,rst,
    input [4:0] A1,A2,A3,
    input [31:0] WD3,
    output [31:0] RD1,RD2
);

reg [31:0] Registers [31:0];

integer i;

initial begin
    for (i = 0; i < 32; i = i + 1)
        Registers[i] = 32'b0;
end

// Register File Read Port 1
assign RD1 = (!rst || A1 == 0) ? 32'b0 :
             (WE3 && A3 != 0 && A3 == A1) ? WD3 :
             Registers[A1];

// Register File Read Port 2
assign RD2 = (!rst || A2 == 0) ? 32'b0 :
             (WE3 && A3 != 0 && A3 == A2) ? WD3 :
             Registers[A2];

// Register File Write
always @(posedge clk)
begin
    if (rst && WE3 && A3 != 0)
        Registers[A3] <= WD3;
end

endmodule
