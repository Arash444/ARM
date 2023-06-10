module MEM_Stage (
    clk,
    rst,
    ALU_res,
    Val_Rm,
    Mem_R_EN,
    Mem_W_EN,
    WB_EN_IN,

    SRAM_data,

    SRAM_WE_N,
    SRAM_addr,
    Ready,
    data_mem,
    WB_EN_OUT
);
    input 
        Mem_R_EN, 
        Mem_W_EN, 
        clk, 
        rst, 
        WB_EN_IN;

    input [31:0] Val_Rm, ALU_res;

    inout [15:0] SRAM_data;

    output 
        SRAM_WE_N,
        Ready,
        WB_EN_OUT;

    output [17:0] SRAM_addr;
    output [31:0] data_mem;


    Mux_2_1 #(1) MUXWB(
        1'b0, 
        WB_EN_IN, 
        Ready, 
        WB_EN_OUT);

    cache_Controller cache_cntrler (
        .clk(clk),
        .rst(rst),
        .wr_en(Mem_W_EN),
        .rd_en(Mem_R_EN),
        .address(ALU_res),
        .write_data(Val_Rm),
        .read_data(data_mem),
        .ready(Ready),
        .SRAM_DQ(SRAM_data),
        .SRAM_ADDR(SRAM_addr),
        .SRAM_WE_N(SRAM_WE_N)
    );
    
endmodule



/*
  assign SRAM_UB_N = 1'b0;
  assign SRAM_LB_N = 1'b0;
  assign SRAM_CE_N = 1'b0;
  assign SRAM_OE_N = 1'b0;

*/