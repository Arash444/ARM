module MEM_Stage (
    clk,
    rst,
    ALU_res,
    Val_Rm,
    Mem_R_EN,
    Mem_W_EN,

    SRAM_data,

    SRAM_WE_N,
    SRAM_addr,
    Ready,
    data_mem
);
    input Mem_R_EN, Mem_W_EN, clk, rst;
    input [31:0] Val_Rm, ALU_res;

    inout [15:0] SRAM_data;

    output 
        SRAM_WE_N,
        Ready;

    output [17:0] SRAM_addr;
    output [31:0] data_mem;

    
    wire [31:0] addr;
    assign addr = (ALU_res - 32'd1024) >> 1;

    SRAMController SC (
        .clk(clk),
        .rst(rst),
        .MEM_W_EN(Mem_W_EN),
        .MEM_R_EN(Mem_R_EN),
        .ALU_res(addr),
        .ST_Value(Val_Rm),
        .SRAM_data(SRAM_data),
        .read_data(data_mem),
        .SRAM_WE_N(SRAM_WE_N),
        .addr(SRAM_addr),
        .Ready(Ready)
    );
    // memory DM(
    //     .clk(clk),
    //     .rst(rst),
    //     .addr(addr),
    //     .MEM_W_EN(Mem_W_EN),
    //     .MEM_R_EN(Mem_R_EN),
    //     .Val_RM(Val_Rm),
    //     .data_mem(data_mem)
    // );
endmodule