module EXE_Stage (
    clk,
    rst,
    pc_in,
    pc
);

    input clk, rst;
    input [31:0] pc_in;
    output [31:0] pc;

    assign pc = pc_in;

endmodule