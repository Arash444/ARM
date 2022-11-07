module Mux_2_1 (
    a,
    b,
    sel,
    out
);
    parameter LEN = 32;

    input sel;
    input [LEN-1:0] a, b;
    output [LEN-1:0] out;

    assign out = (~sel) ? a : b; 

endmodule