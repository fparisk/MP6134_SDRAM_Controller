module whitebox(intf_whitebox whitebox_if);

// Property SDRAM initialization
property sdram_init;
  @(negedge whitebox_if.sdram_clk)
  $fell(whitebox_if.sdram_resetn) |=>                                                                      // reset
  $stable(whitebox_if.sdr_ras_n && whitebox_if.sdr_cas_n &&  whitebox_if.sdr_we_n)[*500]   |-> ##[0:100]   // NOP stable 100us
  $rose(!whitebox_if.sdr_ras_n &&  whitebox_if.sdr_cas_n && !whitebox_if.sdr_we_n)         |-> ##[0:100]   // recharge LHL
  $rose( whitebox_if.sdr_ras_n &&  whitebox_if.sdr_cas_n &&  whitebox_if.sdr_we_n)         |-> ##[0:100]   // NOP
  $rose(!whitebox_if.sdr_ras_n && !whitebox_if.sdr_cas_n &&  whitebox_if.sdr_we_n)         |-> ##[0:100]   // autorefresh LLH
  $rose( whitebox_if.sdr_ras_n &&  whitebox_if.sdr_cas_n &&  whitebox_if.sdr_we_n);/*      |-> ##[0:100]   // NOP
  $rose(!whitebox_if.sdr_ras_n && !whitebox_if.sdr_cas_n &&  whitebox_if.sdr_we_n);*/                      // autorefresh LLH
endproperty

// Property of Rule 3.00 Reset operation
property wb_init_1;
  @(posedge whitebox_if.wb_clk_i)
  $rose(whitebox_if.wb_rst_i)           |->
  whitebox_if.wb_rst_i[*1:$] |-> 
  (whitebox_if.wb_stb_i==0) and (whitebox_if.wb_cyc_i==0);
endproperty

property wb_init_2;
  @(posedge whitebox_if.wb_clk_i)
  $fell(whitebox_if.wb_rst_i)           |-> 
  $isunknown(whitebox_if.wb_rst_i && whitebox_if.wb_rst_i) == 0;
endproperty

// Property of Rule 3.05 Reset operation
property wb_reset_1_cycl;
  @(negedge whitebox_if.wb_clk_i)
  $rose(whitebox_if.wb_rst_i) |=>
  $stable(whitebox_if.wb_rst_i)[*1];
endproperty

// Property of Rule 3.10 Reset operation
property wb_reset;
  @(posedge whitebox_if.wb_clk_i)
  $fell(whitebox_if.sdram_resetn) |-> 
  $rose(whitebox_if.wb_rst_i)     |->
  (whitebox_if.wb_sel_i == 4'h0 && whitebox_if.wb_we_i == 0 && whitebox_if.wb_stb_i == 0 && whitebox_if.wb_cyc_i == 0);
endproperty

// Property of Rule 3.25 Transfer cycle initiaiton
property wb_tci;
  @(posedge whitebox_if.wb_clk_i)
  $rose(whitebox_if.wb_stb_i) |-> 
  $rose(whitebox_if.wb_cyc_i);
endproperty

// Property of Rule 3.35 Transfer cycle initiaiton
property wb_termination;
  @(posedge whitebox_if.wb_clk_i)
  $rose(whitebox_if.wb_cyc_i && whitebox_if.wb_stb_i) |->
  $rose(whitebox_if.wb_ack_o);
 endproperty

// CAS Latency Check
property sdram_CAS_latency_3_cycles;
  @(negedge whitebox_if.sdram_clk)
  $rose(!intf_whitebox.sdr_cas_n && intf_whitebox.sdr_ras_n && intf_whitebox.sdr_we_n) |->
  ((whitebox_if.cfg_sdr_mode_reg) == 13'h033)                                          |-> ##3
  $isunknown(whitebox_if.sdr_dq) == 0;
endproperty

// CAS Latency Check
property sdram_CAS_latency_2_cycles;
  @(negedge whitebox_if.sdram_clk)
  $rose(!intf_whitebox.sdr_cas_n && intf_whitebox.sdr_ras_n && intf_whitebox.sdr_we_n) |->
  ((whitebox_if.cfg_sdr_mode_reg) == 13'h023)                                          |-> ##2
  $isunknown(whitebox_if.sdr_dq) == 0;
endproperty

// CAS Latency Check
property sdram_CAS_latency_1_cycles;
  @(negedge whitebox_if.sdram_clk)
  (whitebox_if.cfg_sdr_mode_reg) != 13'h013;
endproperty

// Sdram init assertion
sdram_initialization: assert property (sdram_init) else $error ("SDRAM_INIT FAILED!!!!!!!!!");

// Rule 3.00
wb_initialization: assert property (wb_init_1 /*wb_init_1 and wb_init_2*/) else $error ("Wishbone Protocol Rule 3.00 violated");

// Rule 3.05
wb_reset_1_clk: assert property(wb_reset_1_cycl) else $error ("Wishbone Protocol Rule 3.05 violated");

// Rule 3.10   
wb_reset_react: assert property(wb_reset) else $error ("Wishbone Protocol Rule 3.10 violated");

// Rule 3.25
wb_SRW_RMW: assert property(wb_tci) else $error ("Wishbone Protocol Rule 3.25 violated");

// Rule 3.35
wb_AND: assert property(wb_termination) else $error ("Wishbone Protocol Rule 3.35 violated");

// CAS Latency
sdram_CasLatency_3: assert property(sdram_CAS_latency_3_cycles) else $error ("3 cycle CAS latency violated.");
sdram_CasLatency_2: assert property(sdram_CAS_latency_2_cycles) else $error ("2 cycle CAS latency violated.");
sdram_CasLatency_1: assert property(sdram_CAS_latency_1_cycles) else $error ("1 cycle CAS latency is invalid.");

endmodule
