module Condition_Check (
    cond,
    status_z,
    status_c,
    status_n,
    status_v,
    cond_check
);

    input [3:0] cond;
    input status_z, status_c, status_n, status_v;
    output reg cond_check;

    always @(cond, status_z, status_c, status_n, status_v) begin
        cond_check = 1'b0;
        case(cond)
            4'b0000: cond_check = (status_z == 1'b1);
            4'b0001: cond_check = (status_z == 1'b0);
            4'b0010: cond_check = (status_c == 1'b1);
            4'b0011: cond_check = (status_c == 1'b0);
            4'b0100: cond_check = (status_n == 1'b1);
            4'b0101: cond_check = (status_n == 1'b0);
            4'b0110: cond_check = (status_v == 1'b1);
            4'b0111: cond_check = (status_v == 1'b0);
            4'b1000: cond_check = ((status_c == 1'b1) & (status_z == 1'b0));
            4'b1001: cond_check = ((status_c == 1'b0) | (status_z == 1'b1));
            4'b1010: cond_check = (status_n == status_v);
            4'b1011: cond_check = (status_n != status_v);
            4'b1100: cond_check = ((status_z == 1'b0) & (status_n == status_v));
            4'b1101: cond_check = ((status_z == 1'b1) & (status_n != status_v));
            4'b1110: cond_check = 1'b1;
            4'b1111: cond_check = 1'b0;
        endcase
    end


endmodule