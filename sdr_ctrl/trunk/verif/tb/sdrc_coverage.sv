class sdram_coverage;

  virtual inft_sdrcntrl intf;
  
  covergroup cov0 @(intf.sdram_clk);
    // Feature_empty: coverpoint intf.empty;
    // Feature_full: coverpoint intf.full;
    // Feature_data: coverpoint intf.data_in {option.auto_bin_max=8;}
    // Feature_empty_seq: coverpoint intf.empty {bins seq = (0=>1=>0);}
    // Feature_full_seq: coverpoint intf.full {bins seq = (0=>1=>0);}
  endgroup

  covergroup Sdram_Coverage @(intf.sdram_clk);

    bank: coverpoint intf.sdram_intf.sdr_ba
    {
      bins bank0 = {0};
			bins bank1 = {1};
			bins bank2 = {2};
			bins bank3 = {3};
    }

    sdram_addr: coverpoint intf.sdr_addr; 

    sdram_cmd: coverpoint {intf.sdram_intf.sdr_cas_n,intf.sdram_intf.sdr_ras_n,intf.sdram_intf.sdr_we_n,intf.sdram_intf.sdr_cs_n}
    {
      bins NOP			         = {4'b1110};
			bins ACTIVE 		       = {4'b1010};
			bins READ 			       = {4'b0110};
			bins WRITE 			       = {4'b0100};
			bins BURSTTERMINATE  	 = {4'b1100};
			bins RECHARGE		       = {4'b1000};
			bins AUTOREFRESH       = {4'b0010};
			bins LOADMODEREGISTER	 = {4'b0000};
    }

    read_write_x_bank_x_addr : cross sdram_cmd, bank, sdram_addr
		{
`ifdef 8_BIT_COL
			bins address_permitted 				= binsof(sdram_addr) intersect {[0:255]};
			bins address_forbidden 			= binsof(sdram_addr) intersect {[256:$]};
`elsif 9_BIT_COL
			bins address_permitted 				= binsof(sdram_addr) intersect {[0:511]};
			bins address_forbidden 			= binsof(sdram_addr) intersect {[512:$]};
`elsif 10_BIT_COL
			bins address_permitted 				= binsof(sdram_addr) intersect {[0:1023]};
			bins address_forbidden 			= binsof(sdram_addr) intersect {[1024:$]};
`else
			bins allowed_addrs 				= binsof(sdram_addr) intersect {[0:2047]};
			bins address_forbidden 			= binsof(sdram_addr) intersect {[2048:$]};
`endif
			ignore_bins cmdsNotNeededOrIgnored = binsof(sdram_cmd) intersect 
			{
				4'b1110, // NOP
				4'b1010, // ACTIVE
				4'b1100, // BURSTTERMINATE
				4'b1000, // RECHARGE
				4'b0001, // AUTOREFRESH
				4'b0010  // LOADMODEREGISTER
			};
		}



  endgroup
  

    
  function new(virtual inft_sdrcntrl intf);
    this.intf = intf;
    Sdram_Coverage =new();
    // cov1 =new();
  endfunction


endclass
