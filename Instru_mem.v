module Instru_mem (
    addr,
    instru
);

    input [31:0] addr;
    output reg [31:0] instru;

    always @(addr) begin
        case(addr)
            32'd0: instru = 32'b00000000001000100000000000000000;
            32'd4: instru = 32'b00000000011001000000000000000000;
            32'd8: instru = 32'b00000000101001100000000000000000;
            32'd12: instru = 32'b00000000111010000001000000000000;
            32'd16: instru = 32'b00000001011011000000000000000000;
            32'd20: instru = 32'b00000001101011100000000000000000;
            default: instru = 32'b0;
        endcase
    end

endmodule