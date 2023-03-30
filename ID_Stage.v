module ID_Stage (
    clk,
    rst,
    // from IF Reg
    instruction,
    // from WB stage
    Result_WB,
    writeBackEn,
    Dest_wb,
    // from hazard detect module
    hazard,
    // from Status Register
    status_z,
    status_c,
    status_n,
    status_v,

    // to next stage
    WB_EN,
    Mem_R_EN,
    Mem_W_EN,
    B,
    S,
    EXE_CMD,
    Val_Rn,
    Val_Rm,
    imm,
    Shift_operand,
    Signed_imm_24,
    Dest,
    // to hazard detect module
    src1,
    src2,
    Two_src
);

    input
        clk,
        rst,
        writeBackEn,
        hazard,
        status_z,
        status_c,
        status_n,
        status_v;
    input [31:0]
        instruction,
        Result_WB;
    input [3:0]
        Dest_wb;


    output
        WB_EN,
        Mem_R_EN,
        Mem_W_EN,
        B,
        S,
        imm,
        Two_src;
    output [3:0]
        EXE_CMD,
        Dest,
        src1,
        src2;
    output [31:0]
        Val_Rn,
        Val_Rm;
    output [11:0]
        Shift_operand;
    output [23:0]
        Signed_imm_24;



    wire
        S_CU, 
        B_CU, 
        Mem_W_EN_CU, 
        Mem_R_EN_CU, 
        WB_EN_CU,
        cond_check,
        cond_or;
    wire [3:0]
        EXE_CMD_CU;

    assign imm = instruction[25];
    assign Shift_operand = instruction[11:0];
    assign Signed_imm_24 = instruction[23:0];
    assign Dest = instruction[15:12];


    ControlUnit CU(
        .OPcode(instruction[24:21]), 
        .mode(instruction[27:26]), 
        .S(instruction[20]), 
        .EXE_CMD(EXE_CMD_CU), 
        .So(S_CU), 
        .B(B_CU), 
        .Mem_W_EN(Mem_W_EN_CU), 
        .Mem_R_EN(Mem_R_EN_CU), 
        .WB_EN(WB_EN_CU)   
        );

    Condition_Check CC (
        .cond(instruction[31:28]),
        .status_z(status_z),
        .status_c(status_c),
        .status_n(status_n),
        .status_v(status_v),
        .cond_check(cond_check)
    );

    assign cond_or = (~cond_check) | hazard;

    Mux_2_1 #(9) Mux_CU_out (
        .a({S_CU, B_CU, Mem_W_EN_CU, Mem_R_EN_CU, WB_EN_CU, EXE_CMD_CU}),
        .b({1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 4'b0000}),
        .sel(cond_or),
        .out({S, B, Mem_W_EN, Mem_R_EN, WB_EN, EXE_CMD})
    );

    Mux_2_1 #(4) Mux_src2 (
        .a(instruction[3:0]),
        .b(instruction[15:12]),
        .sel(Mem_W_EN),
        .out(src2)
    );

    RegisterFile RF (
        .clk(clk),
        .rst(rst),
        .src1(instruction[19:16]),
        .src2(src2),
        .Dest_wb(Dest_wb),
        .Result_wb(Result_WB),
        .writeBackEn(writeBackEn),
        .reg1(Val_Rn),
        .reg2(Val_Rm)
    );

    assign Two_src = (~instruction[25]) | Mem_W_EN;

endmodule