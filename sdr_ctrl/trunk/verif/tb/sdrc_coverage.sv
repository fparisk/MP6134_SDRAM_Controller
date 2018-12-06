class sdram_coverage;

  virtual inft_sdrcntrl intf;
 
  covergroup Sdram_Coverage @(intf.sdram_clk);

    bank: coverpoint intf.sdram_intf.sdr_ba
    {
      bins bank0 = {0};
			bins bank1 = {1};
			bins bank2 = {2};
			bins bank3 = {3};
    }

    sdram_addr: coverpoint intf.sdram_intf.sdr_addr; 

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
  
 
  covergroup Wishbone_Coverage @(intf.sys_clk);

    wishbone_read_write	: coverpoint {intf.wb_intf.wb_stb_i, intf.wb_intf.wb_cyc_i, intf.wb_intf.wb_we_i}
		{
			bins wishbone_read  = {3'b110};
			bins wishbone_write = {3'b111};
		}


    `ifdef 8_BIT_COL
        column	:	coverpoint intf.wb_intf.wb_addr_i[7:0];   // 8 bits para la columna
        row		:  	coverpoint intf.wb_intf.wb_addr_i[21:10]; // 12 bits para la fila
        bank	:	coverpoint intf.wb_intf.wb_addr_i[9:8]      // 2 bits para el bank 
    `elsif 9_BIT_COL
        column	:	coverpoint intf.wb_intf.wb_addr_i[8:0];
        row		:  	coverpoint intf.wb_intf.wb_addr_i[22:11];
        bank	:	coverpoint intf.wb_intf.wb_addr_i[10:9]
    `elsif 10_BIT_COL
        column	:	coverpoint intf.wb_intf.wb_addr_i[9:0];
        row		:  	coverpoint intf.wb_intf.wb_addr_i[23:12];
        bank	:	coverpoint intf.wb_intf.wb_addr_i[11:10]
    `else
        column	:	coverpoint intf.wb_intf.wb_addr_i[10:0];
        row		:  	coverpoint intf.wb_intf.wb_addr_i[24:13];
        bank	:	coverpoint intf.wb_intf.wb_addr_i[12:11]
    `endif
    {
      bins bank0	= {0};
      bins bank1	= {1};
      bins bank2	= {2};
      bins bank3	= {3};
    }

		wb_all	: cross wishbone_read_write, row, column, bank;

    

  endgroup
    
  function new(virtual inft_sdrcntrl intf);
    this.intf = intf;
    Sdram_Coverage    =new();
    Wishbone_Coverage =new();
    // cov1 =new();
  endfunction


endclass
