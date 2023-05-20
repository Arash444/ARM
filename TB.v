module TB ();
    reg 
        clk, 
        rst;

    wire
        SRAM_WE_N;

    wire [15:0] 
        SRAM_DQ;

    wire [17:0]
        SRAM_ADDR;

    ARM ARM1(
        .clk(clk),
        .rst(rst),
        .SRAM_DQ(SRAM_DQ),
        .SRAM_ADDR(SRAM_ADDR),
        .SRAM_WE_N(SRAM_WE_N)
    );

    SRAM SRAM1(
        .clk(clk),
        .rst(rst),
        .write_en(SRAM_WE_N),
        .addr(SRAM_ADDR),
        .data(SRAM_DQ)
    );


    always #5 clk = ~clk;
    
    initial begin 
        clk = 1;
        rst = 0;
        #10 rst = 1;
        #10 rst = 0;
        #1000 $stop;
    end
endmodule