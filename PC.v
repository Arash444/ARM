module PC(
    clk,
    rst,
    freeze,
    in,
    out
);

    input clk, rst, freeze;
    input [31:0] in;
    output reg [31:0] out;

    always @(posedge clk, posedge rst) begin
        if (rst)
            out <= 32'd0;
        else if (freeze)
            out <= out;
        else
            out <= in;
    end

endmodule