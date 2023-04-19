module MEM_Stage (
    clk,
    rst,
    ALU_res,
    Val_Rm,
    Mem_R_EN,
    Mem_W_EN,

    data_mem
);
    input Mem_R_EN, Mem_W_EN, clk, rst;
    input [31:0] Val_Rm, ALU_res;
    output [31:0] data_mem;
    
    wire [31:0] addr;
    assign addr = (ALU_res - 32'd1024) >> 2;

    memory DM(
        .clk(clk),
        .rst(rst),
        .addr(addr),
        .MEM_W_EN(Mem_W_EN),
        .MEM_R_EN(Mem_R_EN),
        .Val_RM(Val_Rm),
        .data_mem(data_mem)
    );
endmodule