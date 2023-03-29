module ControlUnit(
    OPcode,
    mode,
    S,
    EXE_CMD,
    So,
    B,
    Mem_W_EN,
    Mem_R_EN,
    WB_EN
);

    input [3:0] OPcode;
    input [1:0] mode;
    input S;
    
    output reg [3:0] EXE_CMD;
    output reg B;
    output reg Mem_W_EN;
    output reg Mem_R_EN;
    output reg WB_EN;
    output So;

    assign So = S;


    parameter [3:0]
        MOV = 4'b1101,
        MVN = 4'b1111,
        ADD = 4'b0100,
        ADC = 4'b0101,
        SUB = 4'b0010,
        SBC = 4'b0110,
        AND = 4'b0000,
        OR  = 4'b1100,
        EOR = 4'b0001,
        CMP = 4'b1010,
        TST = 4'b1000;


    always @(OPcode, mode, S) begin 
        {EXE_CMD, B, Mem_W_EN, Mem_R_EN, WB_EN} = 8'd0;

        case(mode)
            2'b01: begin
                case(S)
                    1'b1: begin EXE_CMD = 4'b0010; Mem_R_EN = 1'b1; WB_EN = 1'b1; end // LDR
                    1'b0: begin EXE_CMD = 4'b0010; WB_EN = 1'b0; Mem_W_EN = 1'b1; end // STR
                endcase
            end
            2'b10: B = 1'b1; // Branch
            2'b00: begin
                case(OPcode)
                    MOV: begin EXE_CMD = 4'b0001; WB_EN = 1'b1; end
                    MVN: begin EXE_CMD = 4'b1001; WB_EN = 1'b1; end
                    ADD: begin EXE_CMD = 4'b0010; WB_EN = 1'b1; end
                    ADC: begin EXE_CMD = 4'b0011; WB_EN = 1'b1; end
                    SUB: begin EXE_CMD = 4'b0100; WB_EN = 1'b1; end
                    SBC: begin EXE_CMD = 4'b0101; WB_EN = 1'b1; end
                    AND: begin EXE_CMD = 4'b0110; WB_EN = 1'b1; end
                    OR:  begin EXE_CMD = 4'b0111; WB_EN = 1'b1; end
                    EOR: begin EXE_CMD = 4'b1000; WB_EN = 1'b1; end
                    CMP: EXE_CMD = 4'b0100;
                    TST: begin EXE_CMD = 4'b0110; end
                endcase
            end
        endcase
    end

endmodule