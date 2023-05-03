module testbench ();
    reg clk, rst;
    wire [31:0] WB_val;
    ARM ARM1(clk, rst, WB_val);
    always #5 clk = ~clk;
    
    initial begin 
        clk = 1;
        rst = 0;
        #10 rst = 1;
        #10 rst = 0;
        #1000 $stop;
    end
endmodule