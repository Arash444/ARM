module MEM_Reg (
    clk,
    rst,
    ALU_res_in,
    Mem_R_EN_in,
    WB_EN_in,
    dest_in,
    Mem_Data_in,
    freeze,
    
    ALU_res,
    Mem_R_EN,
    WB_EN,
    dest,
    Mem_Data
);

    input clk, rst, WB_EN_in, Mem_R_EN_in, freeze;
    input [3:0] dest_in;
    input [31:0] Mem_Data_in, ALU_res_in;

    output reg WB_EN, Mem_R_EN;
    output reg [3:0] dest;
    output reg [31:0] Mem_Data, ALU_res;

    always @(posedge clk, posedge rst) begin
        if (rst)
            {WB_EN, Mem_R_EN, dest, Mem_Data, ALU_res} <= 70'b0;
        else if (freeze)
            {WB_EN, Mem_R_EN, dest, Mem_Data, ALU_res} <= {WB_EN, Mem_R_EN, dest, Mem_Data, ALU_res};
        else begin
            WB_EN <= WB_EN_in;
            Mem_R_EN <= Mem_R_EN_in;
            ALU_res <= ALU_res_in;
            Mem_Data <= Mem_Data_in;
            dest <= dest_in;
        end
    end
endmodule