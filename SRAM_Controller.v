module SRAM_Controller (
  input clk,
  input rst,
  input wr_en,
  input rd_en,
  input [31:0] address,
  input [31:0] write_data,
  output [31:0] read_data,
  output reg ready,
  inout [15:0] SRAM_DQ,
  output reg [17:0] SRAM_ADDR,
  output reg SRAM_WE_N
);

  wire [17:0] mem_address;
  assign mem_address = (address[17:0] - 18'd1024) >> 1;

  reg load_high_reg_read;
  reg load_low_reg_read;

  reg select_high_write;
  wire [15:0] selected_write;

  assign selected_write = select_high_write ? write_data[31:16] : write_data[15:0];
  assign SRAM_DQ = SRAM_WE_N ? 16'bZZZZ_ZZZZ_ZZZZ_ZZZZ : selected_write;

  register #(.n(16)) high_reg_read (
    .clk(clk),
    .rst(rst),
    .load(load_high_reg_read),
    .d(SRAM_DQ[15:0]),
    .q(read_data[31:16])
  );

  register #(.n(16)) low_reg_read (
    .clk(clk),
    .rst(rst),
    .load(load_low_reg_read),
    .d(SRAM_DQ[15:0]),
    .q(read_data[15:0])
  );

  reg [3:0] ps, ns;

  always @(posedge clk) begin
    if (rst)
      ps <= 4'd0;
    else
      ps <= ns;
  end

  always @(ps, rd_en, wr_en) begin
    ns <= 0;
    case (ps)
      0: ns <= rd_en ? 1 : wr_en ? 6 : 0;
      1: ns <= 2;
      2: ns <= 3;
      3: ns <= 4;
      4: ns <= 5;
      5: ns <= 0;
      6: ns <= 7;
      7: ns <= 8;
      8: ns <= 9;
      9: ns <= 5;
      default: ns <= 0;
    endcase
  end

  always @(ps, rd_en, wr_en) begin
    {ready, load_high_reg_read, load_low_reg_read, select_high_write, SRAM_WE_N} = 5'b00001;
    {SRAM_ADDR} = 18'b00_0000_0000_0000_0000;
    case (ps)
      0: ;
      1: {SRAM_ADDR, load_low_reg_read} = {mem_address, 1'b1};
      2: {SRAM_ADDR, load_high_reg_read} = {mem_address + 18'd1, 1'b1};
      3: ;
      4: ;
      5: {ready} = 1'b1;
      6: {SRAM_ADDR, select_high_write, SRAM_WE_N} = {mem_address, 1'b0, 1'b0};
      7: {SRAM_ADDR, select_high_write, SRAM_WE_N} = {mem_address + 18'd1, 1'b1, 1'b0};
      8: ;
      9: ;
      default: ;
    endcase
  end
endmodule