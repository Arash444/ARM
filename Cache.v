module Cache(
    clk,
    rst,
    read_en,
    write_en,
    sram_ready,
    address,
    input_data,

    write_en2sram,
    read_en2sram,
    ready,
    output_data,
);

    input
        clk,
        rst,
        read_en,
        write_en,
        sram_ready;
    input [31:0]
        address;
    input [63:0]
        input_data;

    output
        write_en2sram,
        read_en2sram,
        ready;
    output [31:0]
        output_data;

    reg [9:0] way0Tag [0:63];
    reg [9:0] way1Tag [0:63];
    reg [31:0] way0First  [0:63];
    reg [31:0] way0Second [0:63];
    reg [31:0] way1First  [0:63];
    reg [31:0] way1Second [0:63];
    reg [63:0] 
        way0Valid,
        way1Valid,
        indexLRU;


    wire 
        hit,
        hitWay0,
        hitWay1,
        validWay0,
        validWay1;
    wire [2:0] offset;
    wire [5:0] index;
    wire [9:0]
        tag,
        tagWay0, 
        tagWay1;
    wire [31:0] 
        readDataQ,
        data,
        dataWay0, 
        dataWay1;


    assign offset = address[2:0];
    assign index = address[8:3];
    assign tag = address[18:9];
    assign dataWay0 = (offset[2] == 1'b0) ? way0First[index] : way0Second[index];
    assign dataWay1 = (offset[2] == 1'b0) ? way1First[index] : way1Second[index];
    assign tagWay0 = way0Tag[index];
    assign tagWay1 = way1Tag[index];
    assign validWay0 = way0Valid[index];
    assign validWay1 = way1Valid[index];
    assign hitWay0 = (tagWay0 == tag && validWay0 == 1'b1);
    assign hitWay1 = (tagWay1 == tag && validWay1 == 1'b1);
    assign hit = hitWay0 | hitWay1;
    assign data = hitWay0 ? dataWay0 :
                hitWay1 ? dataWay1 : 32'dz;
    assign readDataQ = hit ? data :
                    sram_ready ? (offset[2] == 1'b0 ? input_data[31:0] : input_data[63:32]) : 32'bz;
    assign output_data = read_en ? readDataQ : 32'bz;
    assign ready = sram_ready;
    assign read_en2sram = ~hit & read_en;
    assign write_en2sram = write_en;


    always @(posedge clk) begin
        if (write_en) begin
            if (hitWay0) begin
                way0Valid[index] = 1'b0;
                indexLRU[index] = 1'b1;
            end
            else if (hitWay1) begin
                way1Valid[index] = 1'b0;
                indexLRU[index] = 1'b0;
            end
        end
    end

    always @(posedge clk) begin
        if (read_en) begin
            if (hit) begin
                indexLRU[index] = hitWay1;
            end
            else begin
                if (sram_ready) begin
                    if (indexLRU[index] == 1'b1) begin
                        {way0Second[index], way0First[index]} = input_data;
                        way0Valid[index] = 1'b1;
                        way0Tag[index] = tag;
                        indexLRU[index] = 1'b0;
                    end
                    else begin
                        {way1Second[index], way1First[index]} = input_data;
                        way1Valid[index] = 1'b1;
                        way1Tag[index] = tag;
                        indexLRU[index] = 1'b1;
                    end
                end
            end
        end
    end

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            way0Valid = 64'd0;
            way1Valid = 64'd0;
            indexLRU = 64'd0;
        end
    end
endmodule
