module IF_Stage(
    clc,
    rst,
    freeze,
    branch_taken,
    branch_addr,
    pc,
    instruction
);

    input clc, rst, freeze, branch_taken;
    input [31:0] branch_addr;
    output [31:0] pc, instruction;


endmodule