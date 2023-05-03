module ForwardingUnit (
    src1,
    src2,
    Dest_Mem, 
    Dest_WB, 
    WB_EN_MEM,
    WB_EN_WB,
    Forward_EN,

    sel_src1,
    sel_src2
);
    input WB_EN_MEM, WB_EN_WB, Forward_EN;
    input [3:0] src1, src2, Dest_Mem, Dest_WB;
    output reg [1:0] sel_src1, sel_src2;
    
    always @(WB_EN_MEM, WB_EN_WB, src1, Dest_Mem, Dest_WB, Forward_EN) begin
        sel_src1 = 2'b00;
        if (Forward_EN) begin
            if(src1 == Dest_Mem && WB_EN_MEM)
                sel_src1 = 2'b01;
            else if(src1 == Dest_WB && WB_EN_WB)
                sel_src1 = 2'b10;
        end
    end

    always @(WB_EN_MEM, WB_EN_WB, src2, Dest_Mem, Dest_WB, Forward_EN) begin
        sel_src2 = 2'b00;
        if (Forward_EN) begin
            if(src2 == Dest_Mem && WB_EN_MEM)
                sel_src2 = 2'b01;
            else if(src2 == Dest_WB && WB_EN_WB)
                sel_src2 = 2'b10;
        end
    end

endmodule