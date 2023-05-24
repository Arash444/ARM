module Cache (
    rst,
    en_write,
    address,
    in_data1,
    in_data2,

    hit,
    out_data
);
    input 
        rst,
        en_write;

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

    wire [5:0]
        index;

    wire [9:0]
        tag;

    assign index = address[8:3];
    assign tag = address[18:9];

    reg [31:0]
        temp_data0_way0,
        temp_data1_way0,

        temp_data0_way1,
        temp_data1_way1;

    reg [9:0]
        temp_tag_way0,
        temp_tag_way1;


    ////////////////////////////////////////////////////////////////// Read

    always@(index, data0_way0, data1_way0, tag_way0) begin // way0
            temp_data0_way0 = data0_way0[index];
            temp_data1_way0 = data1_way0[index];
            temp_tag_way0 = tag_way0[index];
    end

    always@(index, data0_way1, data1_way1, tag_way1) begin // way1
            temp_data0_way1 = data0_way1[index];
            temp_data1_way1 = data1_way1[index];
            temp_tag_way1 = tag_way1[index];
    end

    ////////////////////////////////////////////////////////////////// Hit or Miss

    always @(tag, index, temp_tag_way0, temp_tag_way1, valid_way0, valid_way1, address, temp_data0_way0, temp_data1_way0, temp_data0_way1, temp_data1_way1) begin
        hit = 1'b0;
        out_data = 32'b0;

        if(temp_tag_way0 == tag && valid_way0[index] == 1'b1) begin // way0
            hit = 1'b1;
            out_data = (address[2] == 1'b0) ? temp_data0_way0 : temp_data1_way0;
            LRU[index] <= 1'b0;
        end

        else if(temp_tag_way1 == tag && valid_way1[index] == 1'b1) begin // way1
            hit = 1'b1;
            out_data = (address[2] == 1'b0) ? temp_data0_way1 : temp_data1_way1;
            LRU[index] <= 1'b1;
        end
    end

    ////////////////////////////////////////////////////////////////// Write

    // always @(posedge en_write) begin
    //     if(en_write) begin
    //         if(LRU[index] == 1'b0) begin // way1
    //             data0_way1[index] <= in_data1;
    //             data1_way1[index] <= in_data2;
    //             tag_way1[index] <= tag;
    //             valid_way1[index] <= 1'b1;
    //             LRU[index] <= 1'b1;
    //         end

    //         else if(LRU[index] == 1'b1) begin // way0
    //             data0_way0[index] <= in_data1;
    //             data1_way0[index] <= in_data2;
    //             tag_way0[index] <= tag;
    //             valid_way0[index] <= 1'b1;
    //             LRU[index] <= 1'b0;
    //         end
    //     end
    // end

endmodule