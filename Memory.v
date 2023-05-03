module memory (
    rst,
    clk,
    addr,
    MEM_W_EN,
    MEM_R_EN,
    Val_RM,
    data_mem
);
    input MEM_R_EN, MEM_W_EN, clk, rst;
    input [31:0] addr, Val_RM;
    output reg [31:0] data_mem;
    integer i; 

    reg [31:0] memory [0:63];

    always@(posedge clk, posedge rst) begin
        if(rst) begin
            for(i = 0; i < 64; i = i + 1) begin
                memory[i] <= 32'b0;
            end
        end
        else if(MEM_W_EN)
            memory[addr] <= Val_RM;
    end

    always@(MEM_R_EN, addr) begin
        data_mem = 32'b0;
        if(MEM_R_EN)
            data_mem = memory[addr];
    end
endmodule