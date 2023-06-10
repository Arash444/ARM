module Cache (
	clk,
	rst,
	wr_en,
	rd_en,
	address,
	data_in,

	hit,
	data_out
);


	input
		clk,
		rst,
		wr_en,
		rd_en;

	input [17:0]
		address;

	input [31:0]
		data_in;

	output
		hit;
		
	output [31:0]
		data_out;


	reg [42:0] way0 [0:63];
	reg [42:0] way1 [0:63];
	reg LRU [0:63];
	

	wire
		valid0,
		valid1,
		hit0,
		hit1;

	wire [5:0]
		input_index;

	wire [9:0]
		input_tag,
		way0_tag,
		way1_tag;


	assign input_index = address[7:2];
	assign input_tag = address[17:8];
	assign way0_tag = way0[input_index][10:1];
	assign way1_tag = way1[input_index][10:1];
	assign valid0 = way0[input_index][0];
	assign valid1 = way1[input_index][0];
	assign hit0 = (way0[input_index][10:1] == input_tag) & valid0 ? 1'b1 : 1'b0;
	assign hit1 = (way1[input_index][10:1] == input_tag) & valid1 ? 1'b1 : 1'b0;
	assign hit = hit0 | hit1;
	assign data_out = hit0 ? way0[input_index][42:11] : way1[input_index][42:11];

	
	integer i;
	initial begin
		for (i = 0; i < 64; i=i+1) begin
			way0[i] = 43'd0;
			way1[i] = 43'd0;
			LRU[i] = 1'd0;
		end
	end


	always @(posedge clk) begin
		if (wr_en) begin
			if (LRU[input_index] == 1'b1) begin
				way0[input_index] <= {data_in, input_tag, 1'b1};
			end
			else begin
				way1[input_index] <= {data_in, input_tag, 1'b1};
			end
			LRU[input_index] <= ~LRU[input_index];
		end
		if (rd_en) begin
			if (hit0) begin
				LRU[input_index] <= 1'b0;
			end
			else if (hit1) begin
				LRU[input_index] <= 1'b1;
			end
		end
	end

endmodule