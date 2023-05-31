module Cache (
    clk,
    rst,
    en_write,
    en_read,
    update_data,
    address,
    in_data1,
    in_data2,

    hit,
    out_data
);
    input
        clk,
        rst,
        update_data,
        en_write,
        en_read;

    input [18:0] 
        address;

    input [31:0]
        in_data1,
        in_data2;

    output reg
        hit;
    output reg [31:0] 
        out_data;

    reg [31:0] data0_way0 [0:63];
    reg [31:0] data1_way0 [0:63];
    reg [9:0] tag_way0 [0:63];
    reg valid_way0 [0:63];


    reg [31:0] data0_way1 [0:63];
    reg [31:0] data1_way1 [0:63];
    reg [9:0] tag_way1 [0:63];
    reg valid_way1 [0:63];

    reg LRU [0:63];

    integer i;
    always @(posedge rst) begin // Initialize
        if(rst) begin
            for(i = 0; i < 64; i = i + 1) begin
                valid_way0[i] <= 1'b0;
                valid_way1[i] <= 1'b0;
                LRU[i] <= 1'b0;
            end
        end
    end

    wire 
        hit_way0,
        hit_way1,
        data0_or_data1;

    wire [5:0]
        index;

    wire [9:0]
        tag;


    wire [31:0]
        temp_data0_way0,
        temp_data1_way0,

        temp_data0_way1,
        temp_data1_way1;

    wire [9:0]
        temp_tag_way0,
        temp_tag_way1;

    ////////////////////////////////////////////////////////////////// assign index, tag, data0_or_data1

    assign index = address[8:3];
    assign tag = address[18:9];
    assign data0_or_data1 = address[2];

    ////////////////////////////////////////////////////////////////// read data & tag

    // way0
    assign temp_data0_way0 = data0_way0[index];
    assign temp_data1_way0 = data1_way0[index];
    assign temp_tag_way0 = tag_way0[index];

    // way1
    assign temp_data0_way1 = data0_way1[index];
    assign temp_data1_way1 = data1_way1[index];
    assign temp_tag_way1 = tag_way1[index];

    ////////////////////////////////////////////////////////////////// Hit or Miss

    assign hit_way0 = (temp_tag_way0 == tag && valid_way0[index] == 1'b1) ? 1'b1 : 1'b0;
    assign hit_way1 = (temp_tag_way1 == tag && valid_way1[index] == 1'b1) ? 1'b1 : 1'b0;
    assign hit = hit_way0 | hit_way1;    


    ////////////////////////////////////////////////////////////////// assign out_data(Read data)

    assign out_data = hit_way0 ? (data0_or_data1 ? temp_data1_way0 : temp_data0_way0) :
                     (hit_way1 ? (data0_or_data1 ? temp_data1_way1 : temp_data0_way1) : 32'b0);


    ////////////////////////////////////////////////////////////////// Update LRU (Read)

    always @ (posedge clk) begin 
        if (en_read) begin
            if (hit_way0) begin
                LRU[index] <= 1'b0;
            end
            else if (hit_way1) begin
                LRU[index] <= 1'b1;
            end
        end
    end
    
    ////////////////////////////////////////////////////////////////// Write

    always @(posedge clk) begin
        if(en_write) begin
            if (update_data) begin // update_data: there is data of address but now we wanna change data
                if(temp_tag_way0 == tag && valid_way0[index] == 1'b1) begin // way0
                    data0_way0[index] <= in_data1;
                    data1_way0[index] <= in_data2;
                    LRU[index] <= 1'b0; 
                end

                else if(temp_tag_way1 == tag && valid_way1[index] == 1'b1) begin // way1
                    data0_way1[index] <= in_data1;
                    data1_way1[index] <= in_data2;
                    LRU[index] <= 1'b1; 
                end
            end
            else begin
                if(LRU[index] == 1'b0) begin // way1
                    data0_way1[index] <= in_data1;
                    data1_way1[index] <= in_data2;
                    tag_way1[index] <= tag;
                    valid_way1[index] <= 1'b1;
                    LRU[index] <= 1'b1;
                end
                else if(LRU[index] == 1'b1) begin // way0
                    data0_way0[index] <= in_data1;
                    data1_way0[index] <= in_data2;
                    tag_way0[index] <= tag;
                    valid_way0[index] <= 1'b1;
                    LRU[index] <= 1'b0;
                end
            end
        end
    end
endmodule