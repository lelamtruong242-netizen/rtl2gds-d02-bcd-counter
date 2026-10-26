`timescale 1ns/1ps

module d02_core_tb;
    reg        clk;
    reg        rst_n;
    reg  [7:0] ui_in;
    wire [7:0] uo_out;
    wire [7:0] uio_out;

    // Gọi module RTL
    d02_core uut (
        .clk(clk),
        .rst_n(rst_n),
        .ui_in(ui_in),
        .uo_out(uo_out),
        .uio_out(uio_out)
    );

    // Tạo xung nhịp 100MHz (chu kỳ 10ns)
    always #5 clk = ~clk;

    initial begin
        // Ghi file sóng .vcd để mở bằng GTKWave
        $dumpfile("wave.vcd");
        $dumpvars(0, d02_core_tb);

        // Khởi tạo
        clk = 0;
        rst_n = 0;
        ui_in = 8'h00;

        // Ca 1: Test Reset
        #20;
        rst_n = 1;
        #10;

        // Ca 2: Bật Enable đếm (ui_in[0] = 1)
        ui_in[0] = 1;
        
        // Đếm chạy qua mốc 09 -> 10 và 99 -> 00
        #3000;

        // Ca 3: Tạm dừng đếm (ui_in[0] = 0)
        ui_in[0] = 0;
        #100;

        // Kết thúc mô phỏng
        $display("Mô phỏng hoàn thành thành công!");
        $finish;
    end
endmodule

