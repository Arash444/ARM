module SramController(
    input clk, rst,
    input MEM_W_EN, MEM_R_EN,
    input [31:0] ALU_res,
    input [31:0] ST_Value,
    output reg [63:0] read_data,
    output reg Ready,            // to freeze other stages

    inout [15:0] SRAM_data,        // SRAM Data bus 16 bits
    output reg [17:0] addr, // SRAM Address bus 18 bits
    output reg SRAM_WE_N         // SRAM Write enable
);

    wire [31:0] memAddr;
    assign memAddr = ALU_res - 32'd1024;

    wire [17:0] sramLowAddr, sramHighAddr, sramUpLowAddess, sramUpHighAddess;
    assign sramLowAddr = {memAddr[18:3], 2'd0};
    assign sramHighAddr = sramLowAddr + 18'd1;
    assign sramUpLowAddess = sramLowAddr + 18'd2;
    assign sramUpHighAddess = sramLowAddr + 18'd3;

    wire [17:0] sramLowAddrWrite, sramHighAddrWrite;
    assign sramLowAddrWrite = {memAddr[18:2], 1'b0};
    assign sramHighAddrWrite = sramLowAddrWrite + 18'd1;

    reg [15:0] dq;
    assign SRAM_data = MEM_W_EN ? dq : 16'bz;

    localparam Idle = 3'd0, DataLow = 3'd1, DataHigh = 3'd2, DataUpLow = 3'd3, DataUpHigh = 3'd4, Done = 3'd5;
    reg [2:0] ps, ns;

    always @(ps or MEM_W_EN or MEM_R_EN) begin
        case (ps)
            Idle: ns = (MEM_W_EN == 1'b1 || MEM_R_EN == 1'b1) ? DataLow : Idle;
            DataLow: ns = DataHigh;
            DataHigh: ns = DataUpLow;
            DataUpLow: ns = DataUpHigh;
            DataUpHigh: ns = Done;
            Done: ns = Idle;
        endcase
    end

    always @(*) begin
        addr = 18'b0;
        SRAM_WE_N = 1'b1;
        Ready = 1'b0;

        case (ps)
            Idle: Ready = ~(MEM_W_EN | MEM_R_EN);
            DataLow: begin
                SRAM_WE_N = ~MEM_W_EN;
                if (MEM_R_EN) begin
                    addr = sramLowAddr;
                    read_data[15:0] <= SRAM_data;
                end
                else if (MEM_W_EN) begin
                    addr = sramLowAddrWrite;
                    dq = ST_Value[15:0];
                end
            end
            DataHigh: begin
                SRAM_WE_N = ~MEM_W_EN;
                if (MEM_R_EN) begin
                    addr = sramHighAddr;
                    read_data[31:16] <= SRAM_data;
                end
                else if (MEM_W_EN) begin
                    addr = sramHighAddrWrite;
                    dq = ST_Value[31:16];
                end
            end
            DataUpLow: begin
                SRAM_WE_N = 1'b1;
                if (MEM_R_EN) begin
                    addr = sramUpLowAddess;
                    read_data[47:32] <= SRAM_data;
                end
            end
            DataUpHigh: begin
                SRAM_WE_N = 1'b1;
                if (MEM_R_EN) begin
                    addr = sramUpHighAddess;
                    read_data[63:48] <= SRAM_data;
                end
            end
            Done: Ready = 1'b1;
        endcase
    end

    always @(posedge clk or posedge rst) begin
        if (rst) ps <= Idle;
        else ps <= ns;
    end
endmodule
