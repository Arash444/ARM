module SRAMController (
    clk,
    rst,
    MEM_W_EN,
    MEM_R_EN,
    ALU_res,
    ST_Value,

    SRAM_data,

    read_data,
    SRAM_WE_N,
    addr,
    Ready
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

    output reg [31:0]
        read_data;

    output reg [17:0]
        addr;

    output reg
        SRAM_WE_N,  
        Ready;
    reg 
        ld_read,
        ld_read_high,
        ld_read_low;

    reg [3:0]
        ps, 
        ns;

    reg [15:0]
        temp_sram_data,
        read_high,
        read_low;

    parameter [3:0]
        IDLE = 4'd0,

        WRITE_LOW = 4'd1,
        WRITE_HIGH = 4'd2,
        WRITE_WAIT = 4'd3,

        ADDR_LOW = 4'd4,
        ADDR_HIGH = 4'd5,
        READ_HIGH = 4'd6,
        
        WAIT = 4'd7,
        READY = 4'd8;

    assign SRAM_data = temp_sram_data;

    always @(ps, ALU_res, ST_Value, MEM_W_EN, MEM_R_EN) begin
        SRAM_WE_N = 1'b1;
        Ready = 1'b1;
        addr = 18'b0;
        temp_sram_data = 16'bz;
        ld_read = 1'b0; 
        ld_read_high = 1'b0;
        ld_read_low = 1'b0;

        case(ps)
            IDLE: begin
                SRAM_WE_N = 1'b1;
                Ready = ~MEM_W_EN & ~MEM_R_EN;
                addr = 18'b0;
                temp_sram_data = 16'bz;
            end
            WRITE_LOW: begin
                SRAM_WE_N = 1'b0;
                Ready = 1'b0;
                addr = ALU_res[17:0];
                temp_sram_data = ST_Value[15:0];
            end
            WRITE_HIGH: begin
                SRAM_WE_N = 1'b0;
                Ready = 1'b0;
                addr = ALU_res[17:0] + 18'd1;
                temp_sram_data = ST_Value[31:16];
            end
            WRITE_WAIT: begin
                SRAM_WE_N = 1'b1;
                Ready = 1'b0;
                addr = 18'b0;
                temp_sram_data = 16'bz;
            end
            ADDR_LOW: begin
                SRAM_WE_N = 1'b1;
                Ready = 1'b0;
                addr = ALU_res[17:0];
                temp_sram_data = 16'bz;
                ld_read_low = 1'b1;
            end
            ADDR_HIGH: begin
                SRAM_WE_N = 1'b1;
                Ready = 1'b0;
                addr = ALU_res[17:0] + 18'd1;
                temp_sram_data = 16'bz;
                ld_read_high = 1'b1;
                //ld_read_low = 1'b1;
            end
            READ_HIGH: begin
                SRAM_WE_N = 1'b1;
                Ready = 1'b0;
                addr = 18'b0;
                temp_sram_data = 16'bz;
                ld_read = 1'b1;
                //ld_read_high = 1'b1;
            end
            WAIT: begin
                SRAM_WE_N = 1'b1;
                Ready = 1'b0;
                addr = 18'b0;
                temp_sram_data = 16'bz;
                //ld_read = 1'b1;
            end
            READY: begin
                SRAM_WE_N = 1'b1;
                Ready = 1'b1;
                addr = 18'b0;
                temp_sram_data = 16'bz;
            end
        endcase
    end

    always @(MEM_W_EN, MEM_R_EN, ps) begin
        ns = IDLE;
        case(ps)
            IDLE: begin
                if(MEM_W_EN)
                    ns = WRITE_LOW;
                else if(MEM_R_EN)
                    ns = ADDR_LOW;
                else
                    ns = IDLE;
            end
            WRITE_LOW: ns = WRITE_HIGH;
            WRITE_HIGH: ns = WRITE_WAIT;
            WRITE_WAIT: ns = WAIT;
            ADDR_LOW: ns = ADDR_HIGH;
            ADDR_HIGH: ns = READ_HIGH;
            READ_HIGH: ns = WAIT;
            WAIT: ns = READY;
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
        end 
        else begin
            if (ld_read)
                read_data <= {read_high, read_low};
            if (ld_read_high)
                read_high <= SRAM_data;
            if (ld_read_low)
                read_low <= SRAM_data;
        end
    end

endmodule