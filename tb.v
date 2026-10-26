`timescale 1ns/1ps

module tb;
    reg clk;
    reg rst_n;
    reg [7:0] uio_in;
    wire [7:0] uo_out;
    wire [7:0] uio_out;

    tt_um_bcd_counter dut (
        .ui_in(8'b0),
        .uo_out(uo_out),
        .uio_in(uio_in),
        .uio_out(uio_out),
        .ena(8'b1),
        .clk(clk),
        .rst_n(rst_n)
    );

    always #5 clk = ~clk;

    initial begin
        $dumpfile("tb.vcd");
        $dumpvars(0, tb);

        clk = 0;
        rst_n = 0;
        uio_in = 8'b0000_0000;

        #20 rst_n = 1;
        #10 uio_in = 8'b0000_0001;

        #2000;

        uio_in = 8'b0000_0000;
        #200;

        $finish;
    end
endmodule 

