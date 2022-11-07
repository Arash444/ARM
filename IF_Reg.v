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

    always @(posedge clk, posedge rst) begin
        if (rst)
            {pc, instruction} <= 64'd0;
        else if (flush)
            {pc, instruction} <= 64'd0;
        else if (freeze)
            {pc, instruction} <= {pc, instruction};
        else 
            {pc, instruction} <= {pc_in, instruction_in};
    end

endmodule