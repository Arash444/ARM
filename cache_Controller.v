module cache_Controller (
  input clk,
  input rst,
  input wr_en,
  input rd_en,
  input [31:0] address,
  input [31:0] write_data,
  output [31:0] read_data,
  output reg ready,
  inout [15:0] SRAM_DQ,
  output [17:0] SRAM_ADDR,
  output SRAM_WE_N
);
  wire done;
  reg sram_rd_en;
  wire sram_wr_en;
  wire [31:0] sram_out;

  assign sram_wr_en = wr_en;

  SRAM_Controller sc(
    clk,
    rst,
    sram_wr_en,
    sram_rd_en,
    address,
    write_data,
    sram_out,
    done,
    SRAM_DQ,
    SRAM_ADDR,
    SRAM_WE_N
  );

  wire hit;
  wire [17:0] mem_address;
  wire [31:0] cache_out;
  assign mem_address = (address[17:0] - 18'd1024);
  assign read_data = hit ? cache_out : sram_out;

    Cache ca (
        .clk(clk),
        .rst(rst),
        .wr_en(wr_en),
        .rd_en(rd_en),
        .address(mem_address),
        .data_in(write_data),

        .hit(hit),
        .data_out(cache_out)
    );


  reg [1:0] ps, ns;

  always @(posedge clk) begin
    if (rst)
      ps <= 2'd0;
    else
      ps <= ns;
  end

  always @(ps, rd_en, wr_en, hit, done) begin
    ns <= 0;
    case (ps)
      0: ns <= rd_en ? 1 : wr_en ? 3 : 0;
      1: ns <= hit ? 0 : 2;
      2: ns <= done ? 0 : 2;
      3: ns <= done ? 0 : 3;
      default: ns <= 0;
    endcase
  end

  always @(ps, wr_en, hit, done) begin
    {ready, sram_rd_en} = 2'b00;
    case (ps)
      0: {ready} = ~wr_en;
      1: {ready, sram_rd_en} = {hit, ~hit};
      2: {ready} = {done};
      3: {ready} = {done};
      default: ;
    endcase
  end
endmodule