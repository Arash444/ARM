module SRAMController (
    clk,
    rst,
    MEM_W_EN,
    MEM_R_EN,
    //update_data,
    hit,
    ALU_res,
    ST_Value,

    SRAM_data,

    read_data,
    local_data,
    cache_write,
    SRAM_WE_N,
    addr,
    Ready
);
    input 
        clk,
        rst,
        hit,
        MEM_W_EN, 
        MEM_R_EN;

    input [31:0]
        ALU_res,
        ST_Value;

    inout [15:0]
        SRAM_data;

    output reg [31:0]
        read_data,
        local_data;

    output reg [17:0]
        addr;

    output reg
        SRAM_WE_N, 
        cache_write, 
        Ready;
    reg 
        ld_read,
        ld_read_high,
        ld_read_low,
        ld_local,
        ld_local_high,
        ld_local_low;

    reg [3:0]
        ps, 
        ns;

    reg [15:0]
        temp_sram_data,
        read_high,
        read_low,
        local_high,
        local_low;

    parameter [3:0]
        IDLE = 4'd0,

        WRITE_LOW = 4'd1,
        WRITE_HIGH = 4'd2,

        READ_LOW = 4'd3,
        READ_HIGH = 4'd4,

        LOCAL_LOW = 4'd5,
        LOCAL_HIGH = 4'd6,
        
        CACHE_WRITE = 4'd7,
        READY = 4'd8;

    assign SRAM_data = temp_sram_data;

    always @(ps, ALU_res, ST_Value, MEM_W_EN, MEM_R_EN) begin
        SRAM_WE_N = 1'b1;
        Ready = 1'b0;
        addr = 18'b0;
        temp_sram_data = 16'bz;
        ld_read = 1'b0; 
        ld_read_high = 1'b0;
        ld_read_low = 1'b0;
        ld_local = 1'b0; 
        ld_local_high = 1'b0;
        ld_local_low = 1'b0;
        cache_write = 1'b0;

        case(ps)
            IDLE: begin
                Ready = ~MEM_W_EN & ~(MEM_R_EN & ~hit);
            end
            WRITE_LOW: begin
                SRAM_WE_N = 1'b0;
                addr = ALU_res[17:0];
                temp_sram_data = ST_Value[15:0];
            end
            WRITE_HIGH: begin
                SRAM_WE_N = 1'b0;
                addr = ALU_res[17:0] + 18'd1;
                temp_sram_data = ST_Value[31:16];
            end
            READ_LOW: begin
                addr = {ALU_res[17:3], 1'b0, ALU_res[1:0]};
                ld_read_low = 1'b1;
            end
            READ_HIGH: begin
                addr ={ALU_res[17:3], 1'b0, ALU_res[1:0]} + 18'd1;
                ld_read_high = 1'b1;
            end
            LOCAL_LOW: begin
                addr = {ALU_res[17:3], 1'b1, ALU_res[1:0]};
                ld_read = 1'b1;
                ld_local_low = 1'b1;
            end
            LOCAL_HIGH: begin
                addr = {ALU_res[17:3], 1'b1, ALU_res[1:0]} + 18'd1;
                ld_local_high = 1'b1;
            end
            CACHE_WRITE: begin
                cache_write = 1'b1;
                ld_local = 1'b1;
            end
            READY: begin
                Ready = 1'b1;
            end
        endcase
    end

    always @(MEM_W_EN, MEM_R_EN, ps) begin
        ns = IDLE;
        case(ps)
            IDLE: begin
                if(MEM_W_EN)
                    ns = WRITE_LOW;
                else if(MEM_R_EN & ~hit)
                    ns = READ_LOW;
                else
                    ns = IDLE;
            end
            WRITE_LOW: ns = WRITE_HIGH;
            WRITE_HIGH: ns = LOCAL_LOW;
            READ_LOW: ns = READ_HIGH;
            READ_HIGH: ns = LOCAL_LOW;
            LOCAL_LOW: ns = LOCAL_HIGH;
            LOCAL_HIGH: ns = CACHE_WRITE;
            CACHE_WRITE: ns = READY;
            READY: ns = IDLE;
        endcase

    end

    always @(posedge clk, posedge rst) begin 
        if(rst)
            ps <= 4'd0;
        else 
            ps <= ns;

    end

    always @(posedge clk, posedge rst) begin 
        if(rst) begin
            read_high <= 16'd0;
            read_low <= 16'd0;
            read_data <= 32'd0;
            local_high <= 16'd0;
            local_low <= 16'd0;
            local_data <= 32'd0;
        end 
        else begin
            if (ld_read)
                read_data <= {read_high, read_low};
            if (ld_read_high)
                read_high <= SRAM_data;
            if (ld_read_low)
                read_low <= SRAM_data;
            if (ld_local)
                local_data <= {local_high, local_low};
            if (ld_local_high)
                local_high <= SRAM_data;
            if (ld_local_low)
                local_low <= SRAM_data;
    end
    end

endmodule