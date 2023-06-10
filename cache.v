module cache (
  input clk, rst,
  input wr_en, rd_en,
  input [17:0] address,
  input [31:0] write_data,
  output [31:0] cache_out,
  output hit
);
  reg [42:0] way0 [0:63];
  reg [42:0] way1 [0:63];
  reg lru [0:63];

  integer i;
  initial begin
    for (i = 0; i < 64; i=i+1) begin
      way0[i] = 43'd0;
      way1[i] = 43'd0;
      lru[i] = 1'd0;
    end
  end

  wire comp0, comp1;
  assign comp0 = way0[address[7:2]][10:1] == address[17:8] ? 1'b1 : 1'b0;
  assign comp1 = way1[address[7:2]][10:1] == address[17:8] ? 1'b1 : 1'b0;

  wire way0_hit, way1_hit;
  assign way0_hit = comp0 & way0[address[7:2]][0];
  assign way1_hit = comp1 & way1[address[7:2]][0];

  assign hit = way0_hit | way1_hit;

  assign cache_out = way0_hit ? way0[address[7:2]][42:11] : way1[address[7:2]][42:11];

  always @(posedge clk) begin
    if (wr_en) begin
      if (lru[address[7:2]] == 1'b1) begin
        way0[address[7:2]] <= {write_data, address[17:8], 1'b1};
      end
      else begin
        way1[address[7:2]] <= {write_data, address[17:8], 1'b1};
      end
      lru[address[7:2]] <= ~lru[address[7:2]];
    end
    if (rd_en) begin
      if (way0_hit) begin
        lru[address[7:2]] <= 1'b0;
      end
      else if (way1_hit) begin
        lru[address[7:2]] <= 1'b1;
      end
    end
  end

endmodule