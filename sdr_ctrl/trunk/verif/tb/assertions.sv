module whitebox(intf_whitebox whitebox_if);

property sdram_init;
  @(negedge whitebox_if.sdram_clk)
  $fell(whitebox_if.sdram_resetn) |=>                                                                      // reset
  $stable(whitebox_if.sdr_ras_n && whitebox_if.sdr_cas_n &&  whitebox_if.sdr_we_n)[*500]   |-> ##[0:100]   // NOP stable 100us
  $rose(!whitebox_if.sdr_ras_n &&  whitebox_if.sdr_cas_n && !whitebox_if.sdr_we_n)         |-> ##[0:100]   // recharge LHL
  $rose( whitebox_if.sdr_ras_n &&  whitebox_if.sdr_cas_n &&  whitebox_if.sdr_we_n)         |-> ##[0:100]   // NOP
  $rose(!whitebox_if.sdr_ras_n && !whitebox_if.sdr_cas_n &&  whitebox_if.sdr_we_n)         |-> ##[0:100]   // autorefresh LLH
  $rose( whitebox_if.sdr_ras_n &&  whitebox_if.sdr_cas_n &&  whitebox_if.sdr_we_n)         |-> ##[0:100]   // NOP
  $rose(!whitebox_if.sdr_ras_n && !whitebox_if.sdr_cas_n &&  whitebox_if.sdr_we_n);                        // autorefresh LLH
endproperty

sdram_initialization: assert property (sdram_init) else $error ("SDRAM_INIT FAILED!!!!!!!!!");

endmodule
