module IF_Reg(
    clk,
    rst,
    freeze,
    flush,
    pc_in,
    instruction_in,
    pc,
    instruction
);

    input clk, rst, freeze, flush;
    input [31:0] pc_in, instruction_in;
    output reg [31:0] pc, instruction;

endmodule