module ARM (clk, rst);
    
    input clk, rst;

    wire [31:0] pc_if,
                pc_if_reg,
                pc_id,
                pc_id_reg,
                pc_exe,
                pc_exe_reg,
                pc_mem,
                pc_mem_reg,
                pc_wb;

    wire [31:0] instruction_if, instruction_if_reg,
                branch_addr;
            
    wire freeze,
        flush,
        branch_taken;

    assign freeze = 1'b0;
    assign flush = 1'b0;
    assign branch_taken = 1'b0;

    assign branch_addr = 32'b0;

    IF_Stage if_st(
        .clk(clk),
        .rst(rst),
        .freeze(freeze),
        .branch_taken(branch_taken),
        .branch_addr(branch_addr),
        .pc(pc_if),
        .instruction(instruction_if)
    );

    IF_Reg if_re (
        .clk(clk),
        .rst(rst),
        .freeze(freeze),
        .flush(flush),
        .pc_in(pc_if),
        .instruction_in(instruction_if),
        .pc(pc_if_reg),
        .instruction(instruction_if_reg)
    );

    /////////////////////////////////////////////////////

    ID_Stage id_st (
        .clk(clk),
        .rst(rst),
        .pc_in(pc_if_reg),
        .pc(pc_id)
    );

    ID_Reg id_re (
        .clk(clk),
        .rst(rst),
        .pc_in(pc_id),
        .pc(pc_id_reg)
    );


    /////////////////////////////////////////////////////

    EXE_Stage exe_st (
        .clk(clk),
        .rst(rst),
        .pc_in(pc_id_reg),
        .pc(pc_exe)
    );

    EXE_Reg exe_re (
        .clk(clk),
        .rst(rst),
        .pc_in(pc_exe),
        .pc(pc_exe_reg)
    );

    /////////////////////////////////////////////////////

    MEM_Stage mem_st (
        .clk(clk),
        .rst(rst),
        .pc_in(pc_exe_reg),
        .pc(pc_mem)
    );

    MEM_Reg mem_re (
        .clk(clk),
        .rst(rst),
        .pc_in(pc_mem),
        .pc(pc_mem_reg)
    );

    /////////////////////////////////////////////////////

    WB_Stage wb_st (
        .clk(clk),
        .rst(rst),
        .pc_in(pc_mem_reg),
        .pc(pc_wb)
    );

endmodule