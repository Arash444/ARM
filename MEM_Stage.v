module MEM_Stage(
    input clk, rst,
    input WB_EN_IN, Mem_R_EN, Mem_W_EN,
    input [31:0] ALU_res, Val_Rm,
    output WB_EN_OUT,
    output [31:0] data_mem,
    output Ready,
    inout [15:0] SRAM_data,
    output [17:0] SRAM_addr,
    output SRAM_WE_N
);

    wire sramReady;
    wire sramMemWEnIn, sramMemREnIn;
    wire [63:0] sramReadData;

    SramController sc (
        .clk(clk),
        .rst(rst),
        .MEM_W_EN(sramMemWEnIn),
        .MEM_R_EN(sramMemREnIn),
        .ALU_res(ALU_res),
        .ST_Value(Val_Rm),
        .read_data(sramReadData),
        .Ready(sramReady),
        .SRAM_data(SRAM_data),
        .addr(SRAM_addr),
        .SRAM_WE_N(SRAM_WE_N)
    );
    
    Cache c (
        .clk(clk),
        .rst(rst),
        .read_en(Mem_R_EN),
        .write_en(Mem_W_EN),
        .sram_ready(sramReady),
        .address(ALU_res),
        .input_data(sramReadData),
        .write_en2sram(sramMemWEnIn),
        .read_en2sram(sramMemREnIn),
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
