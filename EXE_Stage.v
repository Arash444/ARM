module EXE_Stage (
    clk,
    rst,
    Mem_R_EN,
    Mem_W_EN,
    EXE_CMD,
    inC,
    S,
    pc,
    Val1,
    Val_Rm,
    imm,
    shift_operand,
    signed_imm_24,

    ALU_res,
    outN,
    outZ,
    outC,
    outV,
    Branch_Address
);
    input  clk, rst, Mem_R_EN, Mem_W_EN, inC, S, imm;
    input [3:0] EXE_CMD;
    input [31:0] pc, Val1, Val_Rm;
    input [11:0] shift_operand;
    input [23:0] signed_imm_24;

    output [31:0] ALU_res;
    output [31:0] Branch_Address;
    output outN, outZ, outC, outV;

    wire [31:0] Val2, sign_extend, shift;
    wire Mem, tempC, tempZ, tempN, tempV;

    assign Mem = Mem_R_EN | Mem_W_EN; //or

    assign sign_extend = {{8{signed_imm_24[23]}}, signed_imm_24};
    assign shift = sign_extend << 2'd2;
    Adder ADD(shift, pc, Branch_Address);

    ALU OALU(
        EXE_CMD,
        Val1,
        Val2,
        inC,
        ALU_res,
        tempC,
        tempN,
        tempZ,
        tempV);
    StatusRegister SR(
        clk,
        rst,
        S,
        tempN,
        tempZ,
        tempC,
        tempV,
    
        outN,
        outZ,
        outC,
        outV);
    Val2Gen V2G(
        imm,
        Mem,
        shift_operand,
        Val_Rm,
        Val2);

endmodule