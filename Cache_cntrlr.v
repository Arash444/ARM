module Cache_cntrlr (
    clk,
    rst,
    hit,
    MEM_R_EN,
    cache_data,

    //SRAM_data,

    out_data

);

    input 
        clk,
        rst,
        MEM_R_EN,
        hit;
    
    output reg [31:0]
        out_data;

    always @(hit, cache_data) begin 
        if(MEM_R_EN && hit)
            out_data = cache_data;
    end 

    
endmodule