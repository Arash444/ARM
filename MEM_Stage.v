module MEM_Stage(
    clk,
    rst,
    WB_EN_IN,
    Mem_R_EN,
    Mem_W_EN,
    ALU_res,
    Val_Rm,
    
    SRAM_data,

    WB_EN_OUT,
    data_mem,
    Ready,
    SRAM_addr,
    SRAM_WE_N
);

    input 
        clk,
        rst,
        WB_EN_IN,
        Mem_R_EN,
        Mem_W_EN;
    input [31:0]
        ALU_res,
        Val_Rm;

    inout [15:0]
        SRAM_data;

    output
        SRAM_WE_N,
        WB_EN_OUT,
        Ready;
    output [17:0]
        SRAM_addr;
    output [31:0]
        data_mem;


    wire sram_ready;
    wire sram_write_en, sram_read_in;
    wire [63:0] sram_read_data;

    SramController sc (
        .clk(clk),
        .rst(rst),
        .MEM_W_EN(sram_write_en),
        .MEM_R_EN(sram_read_in),
        .ALU_res(ALU_res),
        .ST_Value(Val_Rm),
        .read_data(sram_read_data),
        .Ready(sram_ready),
        .SRAM_data(SRAM_data),
        .addr(SRAM_addr),
        .SRAM_WE_N(SRAM_WE_N)
    );
    
    Cache c (
        .clk(clk),
        .rst(rst),
        .read_en(Mem_R_EN),
        .write_en(Mem_W_EN),
        .sram_ready(sram_ready),
        .address(ALU_res),
        .input_data(sram_read_data),
        .write_en2sram(sram_write_en),
        .read_en2sram(sram_read_in),
        .ready(Ready),
        .output_data(data_mem)
    );


    Mux_2_1 #(1) MUXWB(
        1'b0, 
        WB_EN_IN, 
        Ready, 
        WB_EN_OUT
    );

endmodule
