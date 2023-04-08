module EXE_Reg (
    clk,
    rst,
    ALU_res_in,
    WB_EN_in,
    Mem_R_EN_in,
    Mem_W_EN_in,
    dest_in,
    Val_Rm_in,

    ALU_res,
    Val_Rm,
    WB_EN,
    Mem_R_EN,
    Mem_W_EN,
    dest
);

    input clk, rst, WB_EN_in, Mem_R_EN_in, Mem_W_EN_in;
    input [3:0] dest_in;
    input [31:0] Val_Rm_in, ALU_res_in;

    output reg WB_EN, Mem_R_EN, Mem_W_EN;
    output reg [3:0] dest;
    output reg [31:0] Val_Rm, ALU_res;

    always @(posedge clk, posedge rst) begin
        if (rst)
            {WB_EN, Mem_R_EN, Mem_W_EN, dest, Val_Rm, ALU_res} <= 71'b0;
        else begin
            WB_EN <= WB_EN_in;
            Mem_R_EN <= Mem_R_EN_in;
            Mem_W_EN <= Mem_W_EN_in;
            ALU_res <= ALU_res_in;
            Val_Rm <= Val_Rm_in;
            dest <= dest_in;
        end

    end

endmodule