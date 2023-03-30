module TB ();
    reg clk, rst;
    ARM ARM1(clk, rst);
    always #5 clk = ~clk;
    
    initial begin 
        clk = 1;
        rst = 0;
        #10 rst = 1;
        #10 rst = 0;
        #190 $stop;
    end
endmodule