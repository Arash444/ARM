module ALU (
    ALU_cmd,
    in1,
    in2,
    inC,
    result,
    outC,
    N,
    Z_,
    V
);
    input inC;
    input [3:0] ALU_cmd;
    input [31:0] in1, in2;
    output reg [31:0] result;
    output reg outC, N, Z_, V;

    always @(ALU_cmd, in2, in1, inC) begin
        outC = 1'b0;
        result = 32'b0;
        case(ALU_cmd)
            4'b0001: {outC, result}  = in2; //MOV
            4'b1001: {outC, result}  = ~in2; //MVN
            4'b0010: {outC, result}  = in1 + in2; //ADD
            4'b0011: {outC, result}  = in1 + in2 + inC; //ADC
            4'b0100: {outC, result}  = in1 - in2; //SUB
            4'b0101: {outC, result}  = in1 - in2 - ~inC; //SBC
            4'b0110: {outC, result}  = in1 & in2; //AND
            4'b0111: {outC, result}  = in1 | in2; //ORR
            4'b1000: {outC, result}  = in1 ^ in2; //EOR
            4'b0100: {outC, result}  = in1 - in2; //CMP
            4'b0110: {outC, result}  = in1 & in2; //TST
            4'b0010: {outC, result}  = in1 + in2; //LDR
            4'b0010: {outC, result}  = in1 + in2; //STR
        endcase
    end

    always @(in1, in2,result) begin
        Z_ = 1'b0;
        N = 1'b0;
        V = 1'b0;
        if(result[31] == 1'b1) 
            N = 1'b1;
        if(result == 32'b0) 
            Z_ = 1'b1;
        if(in1[31] & in2[31] & ~result[31])
            V = 1'b1;
        else if(~in1[31] & ~in2[31] & result[31])
            V = 1'b1;
    end



endmodule