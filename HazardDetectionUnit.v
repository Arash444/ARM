module HazardDetection (
    MEM_Dest,
    EXE_Dest,
    MEM_WB_EN,
    EXE_WB_EN,
    src1,
    src2,
    Two_src,
    Hazard);
    input Two_src, MEM_WB_EN, EXE_WB_EN;
    input [3:0] EXE_Dest, MEM_Dest, src1, src2;
    output reg Hazard; 
    always @(EXE_Dest, MEM_Dest, src1, src2, EXE_WB_EN, MEM_WB_EN, Two_src) begin
        Hazard = 1'b0;
        if(src1 == EXE_Dest && EXE_WB_EN)
            Hazard = 1'b1;
        else if(src1 == MEM_Dest && MEM_WB_EN)
            Hazard = 1'b1;
        else if(src2 == EXE_Dest && EXE_WB_EN && Two_src)
            Hazard = 1'b1;
        else if(src2 == MEM_Dest && MEM_WB_EN && Two_src)
            Hazard = 1'b1;
    end
endmodule