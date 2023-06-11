module SramController(
    clk,
    rst,
    MEM_W_EN,
    MEM_R_EN,
    ALU_res,
    ST_Value,

    SRAM_data,

    Ready,
    SRAM_WE_N,
    addr,
    read_data
);

    input
        clk,
        rst,
        MEM_W_EN,
        MEM_R_EN;
    input [31:0]
        ALU_res,
        ST_Value;

    inout [15:0]
        SRAM_data;

    output reg
        Ready,
        SRAM_WE_N;
    output reg [17:0]
        addr;
    output reg [63:0]
        read_data;


    wire [17:0]
        sram_low_addr, 
        sram_high_addr, 
        sram_up_low_addess, 
        sram_up_high_addess,
        sram_low_addr_write,
        sram_high_addr_write;
    wire [31:0]
        Mem_address;

    reg [2:0]
        ps,
        ns;
    reg [15:0]
        dq;
    
    assign Mem_address = ALU_res - 32'd1024;
    assign sram_low_addr = {Mem_address[18:3], 2'd0};
    assign sram_high_addr = sram_low_addr + 18'd1;
    assign sram_up_low_addess = sram_low_addr + 18'd2;
    assign sram_up_high_addess = sram_low_addr + 18'd3;
    assign sram_low_addr_write = {Mem_address[18:2], 1'b0};
    assign sram_high_addr_write = sram_low_addr_write + 18'd1;
    assign SRAM_data = MEM_W_EN ? dq : 16'bz;

    localparam
        IDLE = 3'd0, 
        DataLow = 3'd1, 
        DataHigh = 3'd2, 
        DataUpLow = 3'd3, 
        DataUpHigh = 3'd4, 
        DONE = 3'd5;

    always @(ps or MEM_W_EN or MEM_R_EN) begin
        case (ps)
            IDLE: ns = (MEM_W_EN || MEM_R_EN) ? DataLow : IDLE;
            DataLow: ns = DataHigh;
            DataHigh: ns = DataUpLow;
            DataUpLow: ns = DataUpHigh;
            DataUpHigh: ns = DONE;
            DONE: ns = IDLE;
        endcase
    end

    always @(*) begin
        addr = 18'b0;
        SRAM_WE_N = 1'b1;
        Ready = 1'b0;

        case (ps)
            IDLE: Ready = ~(MEM_W_EN | MEM_R_EN);
            DataLow: begin
                SRAM_WE_N = ~MEM_W_EN;
                if (MEM_R_EN) begin
                    addr = sram_low_addr;
                    read_data[15:0] <= SRAM_data;
                end
                else if (MEM_W_EN) begin
                    addr = sram_low_addr_write;
                    dq = ST_Value[15:0];
                end
            end
            DataHigh: begin
                SRAM_WE_N = ~MEM_W_EN;
                if (MEM_R_EN) begin
                    addr = sram_high_addr;
                    read_data[31:16] <= SRAM_data;
                end
                else if (MEM_W_EN) begin
                    addr = sram_high_addr_write;
                    dq = ST_Value[31:16];
                end
            end
            DataUpLow: begin
                SRAM_WE_N = 1'b1;
                if (MEM_R_EN) begin
                    addr = sram_up_low_addess;
                    read_data[47:32] <= SRAM_data;
                end
            end
            DataUpHigh: begin
                SRAM_WE_N = 1'b1;
                if (MEM_R_EN) begin
                    addr = sram_up_high_addess;
                    read_data[63:48] <= SRAM_data;
                end
            end
            DONE: Ready = 1'b1;
        endcase
    end

    always @(posedge clk or posedge rst) begin
        if (rst)
            ps <= IDLE;
        else 
            ps <= ns;
    end
endmodule
