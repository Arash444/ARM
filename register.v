module register (
    clk,
    rst,
    load,
    d,
    q
);

    parameter n = 32;

    input
        clk,
        rst,
        load;

    input [n-1:0]
        d;

    output reg [n-1:0]
        q;

    always @(posedge clk, posedge rst) begin
        if (rst)
            q <= 0;
        else if (load)
            q <= d;
    end

endmodule
