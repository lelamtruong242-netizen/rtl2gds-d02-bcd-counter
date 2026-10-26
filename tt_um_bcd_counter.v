
module tt_um_bcd_counter (
    input  wire [7:0] ui_in,    // Tín hiệu đầu vào chung
    output wire [7:0] uo_out,   // [6:0]=7 đoạn, [7]=chọn chữ số
    input  wire [7:0] uio_in,   // uio_in[0] = enable đếm
    output wire [7:0] uio_out,  // BCD thô: [7:4] hàng chục, [3:0] hàng đơn vị
    input  wire [7:0] ena,      // Enable chung
    input  wire       clk,      // Xung clock
    input  wire       rst_n     // Reset tích cực mức thấp
);

    reg [3:0] bcd_ones;
    reg [3:0] bcd_tens;
    reg       digit_select;
    reg [3:0] current_digit;
    reg [6:0] seg_out;

    wire ena_count = uio_in[0];

    // 1. Bộ đếm BCD 00 - 99
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            bcd_ones <= 4'd0;
            bcd_tens <= 4'd0;
        end else if (ena_count) begin
            if (bcd_ones == 4'd9) begin
                bcd_ones <= 4'd0;
                if (bcd_tens == 4'd9)
                    bcd_tens <= 4'd0;
                else
                    bcd_tens <= bcd_tens + 1'b1;
            end else begin
                bcd_ones <= bcd_ones + 1'b1;
            end
        end
    end

    // Xuất giá trị BCD thô
    assign uio_out = {bcd_tens, bcd_ones};

    // 2. Chuyển đổi chọn LED
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n)
            digit_select <= 1'b0;
        else
            digit_select <= ~digit_select;
    end

    // Chọn dữ liệu BCD để giải mã ra LED 7 đoạn
    always @(*) begin
        if (digit_select)
            current_digit = bcd_tens;
        else
            current_digit = bcd_ones;
    end

    // 3. Giải mã 7 đoạn (Cathode chung)
    always @(*) begin
        case (current_digit)
            4'd0: seg_out = 7'b011_1111;
            4'd1: seg_out = 7'b000_0110;
            4'd2: seg_out = 7'b101_1011;
            4'd3: seg_out = 7'b100_1111;
            4'd4: seg_out = 7'b110_0110;
            4'd5: seg_out = 7'b110_1101;
            4'd6: seg_out = 7'b111_1101;
            4'd7: seg_out = 7'b000_0111;
            4'd8: seg_out = 7'b111_1111;
            4'd9: seg_out = 7'b110_1111;
            default: seg_out = 7'b000_0000;
        endcase
    end

    assign uo_out = {digit_select, seg_out};

endmodule

