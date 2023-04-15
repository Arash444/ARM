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

    Adder ADD(
        .a(shift),
        .b(pc),
        .out(Branch_Address)
    );


    ALU ALU_ins(
        .ALU_cmd(EXE_CMD),
        .in1(Val1),
        .in2(Val2),
        .inC(inC),
        .result(ALU_res),
        .outC(tempC),
        .N(tempN),
        .Z_(tempZ),
        .V(tempV)
    );


    StatusRegister SR(
        .clk(clk),
        .rst(rst),
        .S(S),
        .inN(tempN),
        .inZ(tempZ),
        .inC(tempC),
        .inV(tempV),
        
        .outN(outN),
        .outZ(outZ),
        .outC(outC),
        .outV(outV)
    );

    Val2Gen V2G(
        .I(imm),
        .Mem(Mem),
        .shift_operand(shift_operand),
        .Val_Rm(Val_Rm),
        .Val2(Val2)
    );


endmodule