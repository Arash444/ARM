module MEM_Stage (
    clk,
    rst,
    ALU_res,
    Val_Rm,
    Mem_R_EN,
    Mem_W_EN,

    Mem_Data
);
    input Mem_R_EN, Mem_W_EN, clk, rst;
    input [31:0] Val_Rm, ALU_res;

    output reg [31:0] Mem_Data;

    assign Mem_Data = 32'b0;

endmodule