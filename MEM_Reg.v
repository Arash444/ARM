module MEM_Reg (
    clk,
    rst,
    pc_in,
    pc
);

    input clk, rst;
    input [31:0] pc_in;
    output reg [31:0] pc;

    always @(posedge clk, posedge rst) begin
        if (rst)
            pc <= 32'd0;
        else
            pc <= pc_in;
    end

endmodule