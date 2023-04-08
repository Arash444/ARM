module StatusRegister (
    clk,
    rst,
    S,
    inN,
    inZ,
    inC,
    inV,

    outN,
    outZ,
    outC,
    outV
);
    input clk, rst, S, inN, inZ, inC, inV;
    output reg outN, outZ, outC, outV;

    always @(negedge clk, posedge rst) begin
        if (rst) begin
            outN <= 1'b0; 
            outZ <= 1'b0; 
            outC <= 1'b0; 
            outV <= 1'b0;
        end
        else if (S) begin
            outN <= inN; 
            outZ <= inZ; 
            outC <= inC; 
            outV <= inV;
        end
    end
endmodule