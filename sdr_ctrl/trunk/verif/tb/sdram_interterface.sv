`timescale 1ns/1ps

interface intf_sdram #(parameter SDR_DW = 32,
                       parameter SDR_BW = 2)(sdram_clk);
    input sdram_clk;
    logic [SDR_BW-1:0]  sdr_dqm;
    logic [1:0]         sdr_ba;
    logic [12:0]        sdr_addr;
    wire [SDR_DW-1:0]   sdr_dq;
    logic sdr_cke;
    logic sdr_ras_n;    
    logic sdr_cas_n;
    logic sdr_we_n;
    logic sdr_cs_n;
    //logic sdram_clk;
    logic sdram_resetn;
    logic sdr_init_done;
    logic [12:0]        cfg_sdr_mode_reg;

endinterface
