module ARM (
    clk,
    rst,
    pc_out
);
    
    input
        clk,
        rst;

    output [31:0] pc_out;

    wire 
        freeze,
        flush,
        branch_taken,
        WB_EN_ID,
        WB_EN_ID_Reg,
        MEM_R_EN_ID,
        MEM_R_EN_ID_Reg,
        MEM_W_EN_ID,
        MEM_W_EN_ID_Reg,
        B_ID,
        B_ID_Reg,
        S_ID,
        S_ID_Reg,
        imm_ID,
        imm_ID_Reg,
        WB_WB_EN,
        Hazard,
        status_z,
        status_c,
        status_n,
        status_v,
        Two_src;
    wire [3:0] 
        EXE_CMD_ID,
        EXE_CMD_ID_Reg,
        dest_ID,
        dest_ID_Reg,
        WB_Dest,
        src1_ID,
        src2_ID;
    wire [11:0] 
        shift_operand_ID,
        shift_operand_ID_Reg;
    wire [23:0]
        signed_imm_24_ID,
        signed_imm_24_ID_Reg;
    wire [31:0] 
        pc_if,
        pc_if_reg,
        pc_ID_Reg,
        pc_exe,
        pc_exe_reg,
        pc_mem,
        pc_mem_reg,
        pc_wb,
        WB_value,
        instruction_if,
        instruction_if_reg,
        branch_addr,
        Val_Rn_ID,
        Val_Rn_ID_Reg,
        Val_Rm_ID,
        Val_Rm_ID_Reg;
        

    assign status_z = 1'b0;
    assign status_c = 1'b0;
    assign status_n = 1'b0;
    assign status_v = 1'b0;
    assign WB_WB_EN = 1'b0;
    assign Hazard = 1'b0;
    assign WB_Dest = 4'b0;
    assign WB_value = 32'b0;
    assign branch_addr = 32'b0;

    assign branch_taken = B_ID_Reg;
    assign flush = branch_taken;
    assign freeze = Hazard;
    assign pc_out = pc_wb;

    ///////////////////////////////////////////////////// IF

    IF_Stage if_st(
        .clk(clk),
        .rst(rst),
        .freeze(freeze),
        .branch_taken(branch_taken),
        .branch_addr(branch_addr),
        .pc(pc_if),
        .instruction(instruction_if)
    );

    IF_Reg if_re (
        .clk(clk),
        .rst(rst),
        .freeze(freeze),
        .flush(flush),
        .pc_in(pc_if),
        .instruction_in(instruction_if),
        .pc(pc_if_reg),
        .instruction(instruction_if_reg)
    );

    ///////////////////////////////////////////////////// ID

    ID_Stage id_st (
        .clk(clk),
        .rst(rst),
        .instruction(instruction_if_reg),
        .Result_WB(WB_value),
        .writeBackEn(WB_WB_EN),
        .Dest_wb(WB_Dest),
        .hazard(Hazard),
        .status_z(status_z),
        .status_c(status_c),
        .status_n(status_n),
        .status_v(status_v),
        .WB_EN(WB_EN_ID),
        .Mem_R_EN(MEM_R_EN_ID),
        .Mem_W_EN(MEM_W_EN_ID),
        .B(B_ID),
        .S(S_ID),
        .EXE_CMD(EXE_CMD_ID),
        .Val_Rn(Val_Rn_ID),
        .Val_Rm(Val_Rm_ID),
        .imm(imm_ID),
        .Shift_operand(shift_operand_ID),
        .Signed_imm_24(signed_imm_24_ID),
        .Dest(dest_ID),
        .src1(src1_ID),
        .src2(src2_ID),
        .Two_src(Two_src)
    );

    ID_Reg id_re (
        .clk(clk),
        .rst(rst),
        .flush(flush),
        .WB_EN_in(WB_EN_ID),
        .MEM_R_EN_in(MEM_R_EN_ID),
        .MEM_W_EN_in(MEM_W_EN_ID),
        .EXE_CMD_in(EXE_CMD_ID),
        .B_in(B_ID),
        .S_in(S_ID),
        .pc_in(pc_if_reg),
        .Val_Rn_in(Val_Rn_ID),
        .Val_Rm_in(Val_Rm_ID),
        .imm_in(imm_ID),
        .shift_operand_in(shift_operand_ID),
        .signed_imm_24_in(signed_imm_24_ID),
        .dest_in(dest_ID),

        .WB_EN(WB_EN_ID_Reg),
        .MEM_R_EN(MEM_R_EN_ID_Reg),
        .MEM_W_EN(MEM_W_EN_ID_Reg),
        .EXE_CMD(EXE_CMD_ID_Reg),
        .B(B_ID_Reg),
        .S(S_ID_Reg),
        .pc(pc_ID_Reg),
        .val_Rn(Val_Rn_ID_Reg),
        .val_Rm(Val_Rm_ID_Reg),
        .imm(imm_ID_Reg),
        .shift_operand(shift_operand_ID_Reg),
        .signed_imm_24(signed_imm_24_ID_Reg),
        .dest(dest_ID_Reg)
    );

    ///////////////////////////////////////////////////// EXE

    EXE_Stage exe_st (
        .clk(clk),
        .rst(rst),
        .pc_in(pc_ID_Reg),
        .pc(pc_exe)
    );

    EXE_Reg exe_re (
        .clk(clk),
        .rst(rst),
        .pc_in(pc_exe),
        .pc(pc_exe_reg)
    );

    ///////////////////////////////////////////////////// MEM

    MEM_Stage mem_st (
        .clk(clk),
        .rst(rst),
        .pc_in(pc_exe_reg),
        .pc(pc_mem)
    );

    MEM_Reg mem_re (
        .clk(clk),
        .rst(rst),
        .pc_in(pc_mem),
        .pc(pc_mem_reg)
    );

    ///////////////////////////////////////////////////// WB

    WB_Stage wb_st (
        .clk(clk),
        .rst(rst),
        .pc_in(pc_mem_reg),
        .pc(pc_wb)
    );

endmodule