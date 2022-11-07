module PC(
    clk,
    rst,
    ld,
    in,
    out
);

    input clk, rst, ld;
    input [31:0] in;
    output reg [31:0] out;

    always @(posedge clk, posedge rst) begin
        if (rst)
            out <= 32'd0;
        else if (ld)
            out <= in;
        else
            out <= out;
    end

endmodule