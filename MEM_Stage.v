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

    
    wire [31:0] 
        addr,
        SRAM_Read,
        in_data1,
        temp_0,
        temp_1,
        local_data,
        cache_data;

    wire 
        cache_write,
        //update_data,
        hit; 

    assign in_data1 = Mem_R_EN ? Val_Rm : data_mem;

    assign addr = (ALU_res - 32'd1024) >> 1;

    assign data_mem = hit ? cache_data :
                      (addr[2] ? temp_1 : temp_0);

    Mux_2_1 #(1) MUXWB(
        1'b0, 
        WB_EN_IN, 
        Ready, 
        WB_EN_OUT);

    SRAMController SC (
        .clk(clk),
        .rst(rst),
        .MEM_W_EN(Mem_W_EN),
        .MEM_R_EN(Mem_R_EN),
        //.update_data(update_data),
        .ALU_res(addr),
        .ST_Value(Val_Rm),
        .SRAM_data(SRAM_data),
        .read_data(temp_0),
        .local_data(temp_1),
        .SRAM_WE_N(SRAM_WE_N),
        .addr(SRAM_addr),
        .Ready(Ready)
    );

    Cache C(
        .rst(rst),
        .en_write(cache_write),
        .update_data(Mem_W_EN),
        .address(ALU_res),
        .in_data1(temp_0),
        .in_data2(temp_1),

        .hit(hit),
        .out_data(cache_data)
    );
endmodule
    // memory DM(
    //     .clk(clk),
    //     .rst(rst),
    //     .addr(addr),
    //     .MEM_W_EN(Mem_W_EN),
    //     .MEM_R_EN(Mem_R_EN),
    //     .Val_RM(Val_Rm),
    //     .data_mem(data_mem)
    // );z