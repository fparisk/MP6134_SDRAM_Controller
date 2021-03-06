`timescale 1ns/1ps

module Clks(output reg sys_clk, output reg sdram_clk);
    parameter P_SYS  = 10;     //    200MHz
    parameter P_SDR  = 20;     //    100MHz

    initial sys_clk = 0;
    initial sdram_clk = 0;

    always #(P_SYS/2) sys_clk = !sys_clk;
    always #(P_SDR/2) sdram_clk = !sdram_clk;

endmodule

