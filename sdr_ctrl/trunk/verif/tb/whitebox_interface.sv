`timescale 1ns/1ps
`define DUV_PATH top.duv

interface intf_whitebox (sdram_clk);
    input sdram_clk;
    
    logic sdr_ras_n;    
    logic sdr_cas_n;
    logic sdr_we_n;
    logic sdram_resetn;
    logic wb_rst_i;
    logic wb_clk_i;
    logic wb_stb_i;
    logic wb_cyc_i;
    logic wb_ack_o;
    logic wb_we_i;
    logic wb_sel_i;
    logic [12:0] cfg_sdr_mode_reg;
    logic [31-1:0] sdr_dq;
    logic [1:0] sdr_ba;

    assign sdr_ras_n = `DUV_PATH.sdr_ras_n;
    assign sdr_cas_n = `DUV_PATH.sdr_cas_n;
    assign sdr_we_n = `DUV_PATH.sdr_we_n;
    assign sdram_resetn = `DUV_PATH.sdram_resetn;
    assign wb_rst_i = `DUV_PATH.wb_rst_i;
    assign wb_clk_i = `DUV_PATH.wb_clk_i;
    assign wb_stb_i = `DUV_PATH.wb_stb_i;
    assign wb_cyc_i = `DUV_PATH.wb_cyc_i;
    assign wb_ack_o = `DUV_PATH.wb_ack_o;
    assign wb_we_i  = `DUV_PATH.wb_we_i;
    assign wb_sel_i = `DUV_PATH.wb_sel_i;
    assign cfg_sdr_mode_reg = `DUV_PATH.cfg_sdr_mode_reg;
    assign sdr_dq = `DUV_PATH.sdr_dq;
    assign sdr_ba = `DUV_PATH.sdr_ba;


    /*logic [SDR_BW-1:0]  sdr_dqm;
    logic [1:0]         sdr_ba;
    logic [12:0]        sdr_addr;
    wire [SDR_DW-1:0]   sdr_dq;
    logic sdr_cke;
    logic sdr_cs_n;
    //logic sdram_clk;
    logic sdram_resetn;
    logic sdr_init_done;*/

endinterface
