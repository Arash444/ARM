module EXE_Stage (
    clk,
    rst,
    Mem_R_EN,
    Mem_W_EN,
    EXE_CMD,
    inC,
    pc,
    Val1,
    Val_Rm,
    imm,
    shift_operand,
    signed_imm_24,
    sel_src1,
    sel_src2,
    ALU_MEM_forward,
    ALU_WB_forward,
    
    ALU_res,
    outN,
    outZ,
    outC,
    outV,
    Branch_Address
);
    input  clk, rst, Mem_R_EN, Mem_W_EN, inC, imm;
    input [1:0] sel_src1, sel_src2;
    input [3:0] EXE_CMD;
    input [31:0] pc, Val1, Val_Rm, ALU_MEM_forward, ALU_WB_forward;
    input [11:0] shift_operand;
    input [23:0] signed_imm_24;

    output [31:0] ALU_res;
    output [31:0] Branch_Address;
    output outN, outZ, outC, outV;

    wire [31:0] Val2, sign_extend, shift, Val_temp2, Val_temp1;
    wire Mem;

    assign Mem = Mem_R_EN | Mem_W_EN; //or

    assign sign_extend = {{8{signed_imm_24[23]}}, signed_imm_24};
    assign shift = sign_extend << 2'd2;
    Adder ADD(shift, pc, Branch_Address);

    Mux_3_1 MX1(
        .a(Val1),
        .b(ALU_MEM_forward),
        .c(ALU_WB_forward),
        .sel(sel_src1),
        .out(Val_temp1)
    );

    Mux_3_1 MX2(
        .a(Val_Rm),
        .b(ALU_MEM_forward),
        .c(ALU_WB_forward),
        .sel(sel_src2),
        .out(Val_temp2)
    );

    Val2Gen V2G(
        .I(imm),
        .Mem(Mem),
        .shift_operand(shift_operand),
        .Val_Rm(Val_temp2),
        .Val2(Val2)
    );

    ALU OALU(
        .ALU_cmd(EXE_CMD),
        .in1(Val_temp1),
        .in2(Val2),
        .inC(inC),
        .result(ALU_res),
        .outC(outC),
        .N(outN),
        .Z_(outZ),
        .V(outV)
    );



endmodule