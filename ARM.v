module ARM (
    clk,
    rst, 
    SRAM_DQ, 
    SRAM_ADDR, 
    SRAM_WE_N
);
    
    input clk, rst;

    inout [15:0] SRAM_DQ;
    
    output [17:0] SRAM_ADDR;

    output SRAM_WE_N;

    wire 
        freeze,
        flush,
        branch_taken,
        WB_EN_ID,
        WB_EN_ID_Reg,
        WB_EN_EXE_Reg,
        WB_EN_MEM,
        MEM_R_EN_ID,
        MEM_R_EN_ID_Reg,
        MEM_R_EN_EXE_Reg,
        MEM_R_EN_MEM_Reg,
        MEM_W_EN_ID,
        MEM_W_EN_ID_Reg,
        MEM_W_EN_EXE_Reg,
        B_ID,
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
        C_ID_REG,
        Two_src,
        tempC, 
        tempZ, 
        tempN, 
        tempV,
        Forward_EN,
        Ready_SRAM,
        Freeze_instruction;

    wire [1:0]
        sel_src1,
        sel_src2;

    wire [3:0] 
        EXE_CMD_ID,
        EXE_CMD_ID_Reg,
        dest_ID,
        dest_ID_Reg,
        dest_EXE_Reg,
        WB_Dest,
        src1_ID,
        src2_ID,
        src1_ID_Reg,
        src2_ID_Reg;

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
        instruction_if,
        instruction_if_reg,
        branch_addr,
        Val_Rn_ID,
        Val_Rn_ID_Reg,
        Val_Rm_ID,
        Val_Rm_ID_Reg,
        Val_Rm_EXE_Reg,
        ALU_res_EXE,
        ALU_res_EXE_Reg,
        ALU_res_MEM_Reg,
        Mem_Data_MEM,
        Mem_Data_MEM_Reg,
        WB_value;


    assign flush = branch_taken;
    assign freeze = Hazard;
    assign Forward_EN = 1'b1;
    
    ///////////////////////////////////////////////////// IF

    assign Freeze_instruction = (~Ready_SRAM) | freeze;

    IF_Stage if_st(
        .clk(clk),
        .rst(rst),
        .freeze(Freeze_instruction),
        .branch_taken(branch_taken),
        .branch_addr(branch_addr),
        .pc(pc_if),
        .instruction(instruction_if)
    );

    IF_Reg if_re (
        .clk(clk),
        .rst(rst),
        .freeze(Freeze_instruction),
        .flush(flush),
        .pc_in(pc_if),
        .instruction_in(instruction_if),
        .pc(pc_if_reg),
        .instruction(instruction_if_reg)
    );

    ///////////////////////////////////////////////////// HAZZARD

    HazardDetection HDU(
        .MEM_Dest(dest_EXE_Reg),
        .EXE_Dest(dest_ID_Reg),
        .MEM_WB_EN(WB_EN_EXE_Reg),
        .EXE_WB_EN(WB_EN_ID_Reg),
        .src1(src1_ID),
        .src2(src2_ID),
        .Two_src(Two_src),
        .Forward_EN(Forward_EN),
        .EXE_MEM_R_EN(MEM_R_EN_ID_Reg),
        .Hazard(Hazard));

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
        .Mem_R_EN_in(MEM_R_EN_ID),
        .Mem_W_EN_in(MEM_W_EN_ID),
        .EXE_CMD_in(EXE_CMD_ID),
        .B_in(B_ID),
        .S_in(S_ID),
        .inC(status_c),
        .pc_in(pc_if_reg),
        .Val_Rn_in(Val_Rn_ID),
        .Val_Rm_in(Val_Rm_ID),
        .imm_in(imm_ID),
        .shift_operand_in(shift_operand_ID),
        .signed_imm_24_in(signed_imm_24_ID),
        .dest_in(dest_ID),
        .src1_in(src1_ID),
        .src2_in(src2_ID),
        .freeze(~Ready_SRAM),

        .WB_EN(WB_EN_ID_Reg),
        .Mem_R_EN(MEM_R_EN_ID_Reg),
        .Mem_W_EN(MEM_W_EN_ID_Reg),
        .EXE_CMD(EXE_CMD_ID_Reg),
        .outC(C_ID_REG),
        .B(branch_taken),
        .S(S_ID_Reg),
        .pc(pc_ID_Reg),
        .Val_Rn(Val_Rn_ID_Reg),
        .Val_Rm(Val_Rm_ID_Reg),
        .imm(imm_ID_Reg),
        .shift_operand(shift_operand_ID_Reg),
        .signed_imm_24(signed_imm_24_ID_Reg),
        .dest(dest_ID_Reg),
        .src1(src1_ID_Reg),
        .src2(src2_ID_Reg)
    );

    ///////////////////////////////////////////////////// EXE

    EXE_Stage exe_st(
        .clk(clk),
        .rst(rst),
        .Mem_R_EN(MEM_R_EN_ID_Reg),
        .Mem_W_EN(MEM_W_EN_ID_Reg),
        .EXE_CMD(EXE_CMD_ID_Reg),
        .inC(C_ID_REG),
        .pc(pc_ID_Reg),
        .Val1(Val_Rn_ID_Reg),
        .Val_Rm(Val_Rm_ID_Reg),
        .imm(imm_ID_Reg),
        .shift_operand(shift_operand_ID_Reg),
        .signed_imm_24(signed_imm_24_ID_Reg),
        .sel_src1(sel_src1),
        .sel_src2(sel_src2),
        .ALU_MEM_forward(ALU_res_EXE_Reg),
        .ALU_WB_forward(WB_value),

        .ALU_res(ALU_res_EXE),
        .outN(tempN),
        .outZ(tempZ),
        .outC(tempC),
        .outV(tempV),
        .Branch_Address(branch_addr)
    );

    EXE_Reg exe_re (
        .clk(clk),
        .rst(rst),
        .ALU_res_in(ALU_res_EXE),
        .WB_EN_in(WB_EN_ID_Reg),
        .Mem_R_EN_in(MEM_R_EN_ID_Reg),
        .Mem_W_EN_in(MEM_W_EN_ID_Reg),
        .dest_in(dest_ID_Reg),
        .Val_Rm_in(Val_Rm_ID_Reg),
        .freeze(~Ready_SRAM),

        .ALU_res(ALU_res_EXE_Reg),
        .Val_Rm(Val_Rm_EXE_Reg),
        .WB_EN(WB_EN_EXE_Reg),
        .Mem_R_EN(MEM_R_EN_EXE_Reg),
        .Mem_W_EN(MEM_W_EN_EXE_Reg),
        .dest(dest_EXE_Reg)
    );
    ///////////////////////////////////////////////////// STATUS REGISTER

    StatusRegister SR(
        .clk(clk),
        .rst(rst),
        .S(S_ID_Reg),
        .inN(tempN),
        .inZ(tempZ),
        .inC(tempC),
        .inV(tempV),
        
        .outN(status_n),
        .outZ(status_z),
        .outC(status_c),
        .outV(status_v)
        );

    ///////////////////////////////////////////////////// FORWARDING UNIT

    ForwardingUnit FU(
        .src1(src1_ID_Reg),
        .src2(src2_ID_Reg),
        .Dest_Mem(dest_EXE_Reg), 
        .Dest_WB(WB_Dest), 
        .WB_EN_MEM(WB_EN_EXE_Reg),
        .WB_EN_WB(WB_WB_EN),
        .Forward_EN(Forward_EN),

        .sel_src1(sel_src1),
        .sel_src2(sel_src2)
    );

    ///////////////////////////////////////////// MEM

    MEM_Stage mem_st (
        .clk(clk),
        .rst(rst),
        .ALU_res(ALU_res_EXE_Reg),
        .Val_Rm(Val_Rm_EXE_Reg),
        .WB_EN_IN(WB_EN_EXE_Reg),
        .Mem_R_EN(MEM_R_EN_EXE_Reg),
        .Mem_W_EN(MEM_W_EN_EXE_Reg),
        
        .SRAM_data(SRAM_DQ),
        .SRAM_WE_N(SRAM_WE_N),
        .SRAM_addr(SRAM_ADDR),
        .Ready(Ready_SRAM),
        .data_mem(Mem_Data_MEM),
        .WB_EN_OUT(WB_EN_MEM)
    );

    MEM_Reg mem_re (
        .clk(clk),
        .rst(rst),
        .ALU_res_in(ALU_res_EXE_Reg),
        .Mem_R_EN_in(MEM_R_EN_EXE_Reg),
        .WB_EN_in(WB_EN_MEM),
        .dest_in(dest_EXE_Reg),
        .Mem_Data_in(Mem_Data_MEM),
        .freeze(~Ready_SRAM),
    
        .ALU_res(ALU_res_MEM_Reg),
        .Mem_R_EN(MEM_R_EN_MEM_Reg),
        .WB_EN(WB_WB_EN),
        .dest(WB_Dest),
        .Mem_Data(Mem_Data_MEM_Reg)
    );

    ///////////////////////////////////////////////////// WB

    WB_Stage wb_st (
        .ALU_res(ALU_res_MEM_Reg),
        .Mem_Data(Mem_Data_MEM_Reg),
        .MEM_R_EN(MEM_R_EN_MEM_Reg),
        .result(WB_value)
    );

endmodule