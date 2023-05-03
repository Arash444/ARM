module ID_Reg (
    clk,
    rst,
    flush,
    WB_EN_in,
    Mem_R_EN_in,
    Mem_W_EN_in,
    EXE_CMD_in,
    B_in,
    S_in,
    inC,
    pc_in,
    Val_Rn_in,
    Val_Rm_in,
    imm_in,
    shift_operand_in,
    signed_imm_24_in,
    dest_in,
    src1_in,
    src2_in,

    WB_EN,
    Mem_R_EN,
    Mem_W_EN,
    EXE_CMD,
    B,
    S,
    outC,
    pc,
    Val_Rn,
    Val_Rm,
    imm,
    shift_operand,
    signed_imm_24,
    dest,
    src1,
    src2
);

    input
        clk,
        rst,
        flush,
        WB_EN_in,
        Mem_R_EN_in,
        Mem_W_EN_in,
        B_in,
        S_in,
        imm_in,
        inC;
    input [3:0] 
        EXE_CMD_in,
        dest_in,
        src1_in,
        src2_in;
    input [31:0]
        pc_in,
        Val_Rn_in,
        Val_Rm_in;
    input [11:0] shift_operand_in;
    input [23:0] signed_imm_24_in;

    output reg  WB_EN,
                Mem_R_EN,
                Mem_W_EN,
                B,
                S,
                imm,
                outC;
    output reg [3:0] 
        EXE_CMD,
        src1,
        src2,
        dest;
    output reg [31:0]
        pc,
        Val_Rn,
        Val_Rm;
    output reg [11:0] shift_operand;
    output reg [23:0] signed_imm_24;

    always @(posedge clk, posedge rst) begin
        if (rst)
            {WB_EN, Mem_R_EN, Mem_W_EN, B, S, imm, EXE_CMD, pc, Val_Rn, Val_Rm, shift_operand, signed_imm_24, dest, outC, src1, src2} <= 155'b0;
        else if (flush)
            {WB_EN, Mem_R_EN, Mem_W_EN, B, S, imm, EXE_CMD, pc, Val_Rn, Val_Rm, shift_operand, signed_imm_24, dest, outC, src1, src2} <= 155'b0;
        else begin
            WB_EN <= WB_EN_in;
            Mem_R_EN <= Mem_R_EN_in;
            Mem_W_EN <= Mem_W_EN_in;
            B <= B_in;
            S <= S_in;
            imm <= imm_in;
            EXE_CMD <= EXE_CMD_in;
            pc <= pc_in;
            Val_Rn <= Val_Rn_in;
            Val_Rm <= Val_Rm_in;
            shift_operand <= shift_operand_in;
            signed_imm_24 <= signed_imm_24_in;
            dest <= dest_in;
            outC <= inC;
            src1 <= src1_in;
            src2 <= src2_in;
        end

    end

endmodule