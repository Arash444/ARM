module SRAM (
    rst,
    clk,
    write_en,
    addr,
    data,
);

    input
        clk,
        rst,
        write_en;

    input [17:0]
        addr;

    inout [15:0]
        data;

    integer i; 

    reg [16:0] memory [0:63];

    assign data = (write_en) ? memory[addr] : 16'bz;

    always@(posedge clk, posedge rst) begin
        if(rst) begin
            for(i = 0; i < 64; i = i + 1) begin
                memory[i] <= 16'b0;
            end
        end
        else if(write_en) begin
            memory[addr] <= data;
        end
    end

endmodule