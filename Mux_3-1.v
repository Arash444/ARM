module Mux_3_1 (
    a,
    b,
    c,
    sel,
    out
);
    parameter LEN = 32;

    input [1:0] sel;
    input [LEN-1:0] a, b, c;
    output [LEN-1:0] out;

    assign out = (sel[1]) ? c : (~sel[0] ? a : b); 

endmodule