`timescale 1ns/1ps

// Helper methods to configure DUV BW configuration
class DuvConfigurationUtils;

    function bit[1:0] getSdrWidth(int dw);
        if (dw == 32) begin
            return 2'b00;
        end
        else if (dw == 16) begin
            return 2'b01;
        end if (dw == 8) begin
            return 2'b10;
        end
        return 2'b01;

    endfunction
endclass

// top module
module top();

    DuvConfigurationUtils duvConfigUtils = new();

    parameter P_SYS  = 10;     //    200MHz
    parameter P_SDR  = 20;     //    100MHz

    // General
    reg  RESETN;
    reg  sys_clk;
    reg  sdram_clk;

    initial sys_clk = 0;
    initial sdram_clk = 0;

    always #(P_SYS/2) sys_clk = !sys_clk;
    always #(P_SDR/2) sdram_clk = !sdram_clk;

    parameter SDR_DW = 32;
    parameter SDR_BW = 2;
    //parameter dw = 32;
    parameter APP_AW = 26;

    // Interface instance
    inft_sdrcntrl #(.SDR_DW(SDR_DW), .SDR_BW(SDR_BW), .APP_AW(APP_AW)) sdrc_intf(
        sys_clk,
        sdram_clk
    );

    sdrc_top #(.SDR_DW(SDR_DW), .SDR_BW(SDR_BW)) duv(
        // system
        .cfg_sdr_width      (duvConfigUtils.getSdrWidth(SDR_DW)),
        .cfg_colbits        (2'b00),    // double check, org top mentioned only 8bit case
        
        // wish bone
        .wb_rst_i           (!sdrc_intf.resetn), 
        .wb_clk_i           (sdrc_intf.sys_clk),
        .wb_stb_i           (sdrc_intf.wb_intf.wb_stb_i),
        .wb_ack_o           (sdrc_intf.wb_intf.wb_ack_o),
        .wb_addr_i          (sdrc_intf.wb_intf.wb_addr_i),
        .wb_we_i            (sdrc_intf.wb_intf.wb_we_i),
        .wb_dat_i           (sdrc_intf.wb_intf.wb_dat_i),
        .wb_sel_i           (sdrc_intf.wb_intf.wb_sel_i),
        .wb_dat_o           (sdrc_intf.wb_intf.wb_dat_o),
        .wb_cyc_i           (sdrc_intf.wb_intf.wb_cyc_i),
        .wb_cti_i           (sdrc_intf.wb_intf.wb_cti_i),

        // SDRAM
        .sdram_clk          (sdrc_intf.sdram_clk),
        .sdram_resetn       (sdrc_intf.resetn),
        .sdr_cs_n           (sdrc_intf.sdram_intf.sdr_cs_n),
        .sdr_cke            (sdrc_intf.sdram_intf.sdr_cke),
        .sdr_ras_n          (sdrc_intf.sdram_intf.sdr_ras_n),
        .sdr_cas_n          (sdrc_intf.sdram_intf.sdr_cas_n),
        .sdr_we_n           (sdrc_intf.sdram_intf.sdr_we_n),
        .sdr_dqm            (sdrc_intf.sdram_intf.sdr_dqm),
        .sdr_ba             (sdrc_intf.sdram_intf.sdr_ba),
        .sdr_addr           (sdrc_intf.sdram_intf.sdr_addr), 
        .sdr_dq             (sdrc_intf.sdram_intf.sdr_dq),

        // Parameters */
        .sdr_init_done      (sdrc_intf.sdram_intf.sdr_init_done),
        .cfg_req_depth      (2'h3),  //how many req. buffer should hold
        .cfg_sdr_en         (1'b1),
        .cfg_sdr_mode_reg   (13'h033),
        .cfg_sdr_tras_d     (4'h4),
        .cfg_sdr_trp_d      (4'h2),
        .cfg_sdr_trcd_d     (4'h2),
        .cfg_sdr_cas        (3'h3),
        .cfg_sdr_trcar_d    (4'h7),
        .cfg_sdr_twr_d      (4'h1),
        .cfg_sdr_rfsh       (12'h100), // reduced from 12'hC35
        .cfg_sdr_rfmax      (3'h6)
    );

endmodule
