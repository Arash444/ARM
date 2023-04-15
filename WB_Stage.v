module WB_Stage (
    ALU_res,
    Mem_Data,
    MEM_R_EN,
    result
);

    input MEM_R_EN;
    input [31:0] Mem_Data, ALU_res;
    output [31:0] result;

    Mux_2_1 MUX32(ALU_res, Mem_Data, MEM_R_EN, result);

endmodule