`timescale 1ns/1ps

module tb_advanced;
    reg clk;
    reg rst_n;
    reg [7:0] ui_in;
    reg [7:0] uio_in;
    wire [7:0] uo_out;
    wire [7:0] uio_out;

    tt_um_bcd_counter dut (
        .ui_in(ui_in),
        .uo_out(uo_out),
        .uio_in(uio_in),
        .uio_out(uio_out),
        .ena(8'b1),
        .clk(clk),
        .rst_n(rst_n)
    );

    always #5 clk = ~clk;

    initial begin
        clk = 0;
        rst_n = 0;
        ui_in = 8'h00;
        uio_in = 8'h00;

        $dumpfile("tb_advanced.vcd");
        $dumpvars(0, tb_advanced);

        // Dòng lệnh để in bảng log ra Terminal
        $monitor("Time=%0t | rst_n=%b | uio_in[0]=%b | uio_out(BCD)=%h | uo_out=%b", 
                 $time, rst_n, uio_in[0], uio_out, uo_out);

        #20 rst_n = 1;
        #10 uio_in[0] = 1'b1;

        #200 uio_in[0] = 1'b0;
        #100 uio_in[0] = 1'b1;
        #2000;

        $finish;
    end
endmodule


