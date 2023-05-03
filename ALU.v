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

    always @(result, ALU_cmd, in2, in1, inC) begin
        outC = 1'b0;
        result = 32'b0;
        V = 1'b0;
        case(ALU_cmd)
            4'b0001: result = in2; //MOV
            4'b1001: result  = ~in2; //MVN
            4'b0010: begin 
                {outC, result} = in1 + in2;
                if(in1[31] & in2[31] & ~result[31])
                    V = 1'b1;
                else if(~in1[31] & ~in2[31] & result[31])
                    V = 1'b1;
            end //ADD
            4'b0011: begin 
                {outC, result}  = in1 + in2 + {31'b0, inC};   
                if(in1[31] & in2[31] & ~result[31])
                    V = 1'b1;
                else if(~in1[31] & ~in2[31] & result[31])
                    V = 1'b1;
            end //ADC
            4'b0100: begin 
                {outC, result}  = in1 - in2;  
                if(in1[31] & ~in2[31] & ~result[31])
                    V = 1'b1;
                else if(~in1[31] & in2[31] & result[31])
                    V = 1'b1;
            end //SUB
            4'b0101: begin 
                {outC, result}  = in1 - in2 - {31'b0, ~inC};  
                if(in1[31] & ~in2[31] & ~result[31])
                    V = 1'b1;
                else if(~in1[31] & in2[31] & result[31])
                    V = 1'b1;
            end //SBC
            4'b0110: result  = in1 & in2; //AND
            4'b0111: result  = in1 | in2; //ORR
            4'b1000: result  = in1 ^ in2; //EOR
            4'b0100: begin 
                {outC, result}  = in1 - in2;
                if(in1[31] & ~in2[31] & ~result[31])
                    V = 1'b1;
                else if(~in1[31] & in2[31] & result[31])
                    V = 1'b1;
            end //CMP
            4'b0110: result  = in1 & in2; //TST
            4'b0010: begin 
                {outC, result}  = in1 + in2;
                if(in1[31] & in2[31] & ~result[31])
                    V = 1'b1;
                else if(~in1[31] & ~in2[31] & result[31])
                    V = 1'b1;
            end //LDR
            4'b0010: begin 
                {outC, result}  = in1 + in2;
                if(in1[31] & in2[31] & ~result[31])
                    V = 1'b1;
                else if(~in1[31] & ~in2[31] & result[31])
                    V = 1'b1;
            end //STR
        endcase
    end

    always @(result) begin
        Z_ = 1'b0;
        N = 1'b0;
        if(result[31] == 1'b1) 
            N = 1'b1;
        if(result == 32'b0) 
            Z_ = 1'b1;
    end



endmodule