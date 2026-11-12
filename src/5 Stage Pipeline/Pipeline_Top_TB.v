`timescale 1ps/1ps
`include "Pipeline_Top.v"

module Pipeline_Top_TB();

reg clk=1'b0,rst;

always begin
    clk=~clk;
    #50;
end

initial begin
    rst<=1'b0;
    #100;
    rst<=1'b1;
    #2000;
    $finish;
end

initial 
    begin
        $dumpfile("Pipeline_Top.vcd");
        $dumpvars(0,Pipeline_Top_TB);
    end

Pipeline_Top Pipeline_Top(
    .clk(clk),
    .rst(rst)
);
endmodule