module PC_Module(
    input [31:0] PCNext,
    input clk,rst,
    input StallF,

    output reg [31:0] PC 
);
always @(posedge clk or negedge rst)
    begin
        if(rst==0)
        begin
            PC<=32'h00000000;
        end
        else if (!StallF)
        begin
            PC<=PCNext;
        end
    end    
endmodule               