class sdrcEnv2 extends sdrcEnv;
    sdrcSB2 sb2;
    sdrcMon2 mon2;
    sdrcDrv2 drv2;
    sdram_coverage sc;
    //virtual inft_sdrcntrl inft; // Deprecated for second project

    function new (virtual inft_sdrcntrl inft,);
      super.new(inft);
      $display("Creating SDRC Environment");
      super.sb = new();
      super.drv = new (inft, sb);
      super.mon = new (inft, sb);
      sb2 = new();
      drv2 = new (inft, sb2);
      mon2 = new (inft, sb2);
      sc = new(inft);


    endfunction
endclass
