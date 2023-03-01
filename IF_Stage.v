module IF_Stage(
    clk,
    rst,
    freeze,
    branch_taken,
    branch_addr,
    pc,
    instruction
);

    input clk, rst, freeze, branch_taken;
    input [31:0] branch_addr;
    output [31:0] pc, instruction;

    wire [31:0] pc_out, adder_out, mux_out;

    assign pc = adder_out;

    PC pc_inst (
        .clk(clk),
        .rst(rst),
        .ld(freeze),
        .in(mux_out),
        .out(pc_out)
    );

    Adder adder_pc_4 (
        .a(32'd4),
        .b(pc_out),
        .out(adder_out)
    );

    Mux_2_1 mux_2_1_inst (
        .a(adder_out),
        .b(branch_addr),
        .sel(branch_taken),
        .out(mux_out)
    );

    Instru_mem inst_mem (
        .addr(pc_out),
        .instru(instruction)
    );

endmodule