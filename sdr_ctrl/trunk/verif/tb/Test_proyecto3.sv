program testcase(inft_sdrcntrl intf);

  // sdrcEnv env = new(intf); // Deprecated for second project.
  sdrcEnv2 env2 = new(intf);
  int k;
  reg [31:0] StartAddr;
  
  initial 
  begin
    // set test execution count
    env2.mon2.testCasesCount = 8;
    env2.mon2.notExecTestCasesCount = env2.mon2.testCasesCount;

    // Tests to execute

    // CAS Latency case 1 (invalid value)
    // reset
    env2.drv2.ModifyModeRegister(13'h013);
    env2.drv2.reset();

    // CAS Latency case 2 (2 cycles)
    // reset
    env2.drv2.ModifyModeRegister(13'h023);
    env2.drv2.reset();
    tc1_single_read();
    
    // CAS Latency case 3 (3 cycles)
    // reset
    env2.drv2.ModifyModeRegister(13'h033);
    env2.drv2.reset();

    tc8_configurable_data_width();
    tc7_4_bank_feature();

    tc2_x2_read();
    tc3_page_cross_over();
    tc5_x24_Write_and_Read_diff_row_bank();
    tc4_x4_Write_Read();
    tc6_write_read_different_order();

    // check test exec. results
    env2.mon2.Check();
  end
     
  task tc1_single_read();
    begin
      $display("-------------------------------------- ");
      $display(" Case-1a: Single Write/Read Case        ");
      $display("-------------------------------------- ");
  
      env2.drv2.BurstWrite_rnd_addr();
      #1000;
      env2.mon2.BurstRead();

      env2.mon2.notExecTestCasesCount = env2.mon2.notExecTestCasesCount -1;
      
      $display("-------------------------------------- ");
      $display(" End-1: Single Write/Read Case        ");
      $display("-------------------------------------- ");
    end
  endtask

  // Test case 2 Single Write/Read Case
  task tc2_x2_read();
    begin
      $display("-------------------------------------- ");
      $display(" Case-2: x2 Write/Read Case        ");
      $display("-------------------------------------- ");
  
      // single write and single read
      env2.drv2.BurstWrite_rnd_addr();
      env2.mon2.BurstRead();

      env2.drv2.BurstWrite_rnd_addr();
      env2.mon2.BurstRead();
      
      env2.mon2.notExecTestCasesCount = env2.mon2.notExecTestCasesCount -1;

      $display("-------------------------------------- ");
      $display(" End-2: x2 Write/Read Case        ");
      $display("-------------------------------------- ");
    end
  endtask

  // Case:3 Create a Page Cross Over
  task tc3_page_cross_over();
    begin
      
      $display("----------------------------------------");
      $display(" Case-3 Create a Page Cross Over        ");
      $display("----------------------------------------");

      env2.drv2.BurstWrite_page_cross_over();  
      env2.drv2.BurstWrite_page_cross_over();  
      env2.drv2.BurstWrite_page_cross_over();  

      env2.mon2.BurstRead();  
      env2.mon2.BurstRead();  
      env2.mon2.BurstRead();
      
      env2.mon2.notExecTestCasesCount = env2.mon2.notExecTestCasesCount -1;
      
      $display("-------------------------------------- ");
      $display(" End-3 Create a Page Cross Over");
      $display("-------------------------------------- ");
    end
  endtask


  // Case:4 4 Write & 4 Read
  task tc4_x4_Write_Read();
    begin
      $display("----------------------------------------");
      $display(" Case:4 x4 Write & Read                ");
      $display("----------------------------------------");
      
      env2.drv2.BurstWrite_rnd_addr();  
      env2.drv2.BurstWrite_rnd_addr();  
      env2.drv2.BurstWrite_rnd_addr();  
      env2.drv2.BurstWrite_rnd_addr();  
      env2.mon2.BurstRead();  
      env2.mon2.BurstRead();  
      env2.mon2.BurstRead();  
      env2.mon2.BurstRead();
      
      env2.mon2.notExecTestCasesCount = env2.mon2.notExecTestCasesCount -1;

      $display("-------------------------------------- ");
      $display(" End-4 x4 Write &  Read");
      $display("-------------------------------------- ");  
    end
  endtask

  // Case:5 24 Write & 24 Read With Different Bank and Row
  task tc5_x24_Write_and_Read_diff_row_bank();
    begin
      $display("---------------------------------------");
      $display(" Case:5 24 Write & 24 Read With Different Bank and Row ");
      $display("---------------------------------------");

      env2.drv2.BurstWrite_diff_row_bank();     // addr=rnd, bank=rand
      env2.drv2.BurstWrite_diff_row_bank(555);  // addr=555, bank=rnd
      env2.drv2.BurstWrite_diff_row_bank(,1);   // addr=rnd, bank=1

      env2.mon2.BurstRead();  
      env2.mon2.BurstRead();  
      env2.mon2.BurstRead();

      env2.mon2.notExecTestCasesCount = env2.mon2.notExecTestCasesCount -1;

      $display("-------------------------------------- ");
      $display(" End-5 24 Write & 24 Read With Different Bank and Row");
      $display("-------------------------------------- ");              
    end
  endtask

  // Case6: Writes/Reads in dofferent order
  task tc6_write_read_different_order();
    begin
      $display("-------------------------------------- ");
      $display(" Case-6: Writes/Reads in different order        ");
      $display("-------------------------------------- ");
  
      env2.drv2.BurstWrite_rnd_addr();
      env2.drv2.BurstWrite_rnd_addr();

      env2.mon2.BurstRead();

      env2.drv2.BurstWrite_rnd_addr();
      env2.drv2.BurstWrite_rnd_addr();
      env2.drv2.BurstWrite_rnd_addr();
      env2.drv2.BurstWrite_rnd_addr();
      env2.drv2.BurstWrite_rnd_addr();
      env2.drv2.BurstWrite_rnd_addr();      
      
      #1000;

      env2.mon2.BurstRead();
      env2.mon2.BurstRead();

      env2.drv2.BurstWrite_rnd_addr();

      env2.mon2.BurstRead();
      env2.mon2.BurstRead();

      #1000;

      env2.drv2.BurstWrite_rnd_addr();
      env2.drv2.BurstWrite_rnd_addr();

      #1000;

      env2.mon2.BurstRead();
      env2.mon2.BurstRead();
      env2.mon2.BurstRead();

      #1000;

      env2.drv2.BurstWrite_rnd_addr();
      env2.drv2.BurstWrite_rnd_addr();

       #1000;

      env2.mon2.BurstRead();
      env2.mon2.BurstRead();
      env2.mon2.BurstRead();
      env2.mon2.BurstRead();
      env2.mon2.BurstRead();

      env2.mon2.notExecTestCasesCount = env2.mon2.notExecTestCasesCount -1;
      
      $display("-------------------------------------- ");
      $display(" End-6: Writes/Reads in different order ");
      $display("-------------------------------------- ");
    end
  endtask

  // Case:7 Four Bank feature
  task tc7_4_bank_feature();
    begin
      
      $display("----------------------------------------");
      $display(" Case-7 Four Bank feature               ");
      $display("----------------------------------------");
 
      env2.drv2.BurstWrite_diff_col_row_bank_data(1,0,0,1,6);	// Row:1, Bank:0, Col:0, BurstSize:1, Data:6
      env2.mon2.BurstRead();
      if (intf.sdram_intf.sdr_ba != 0) begin
   	env2.mon2.sb.ErrCnt ++;
	$display("ERROR, incorrect programmed bank!!");
      end

      #1000;

      env2.drv2.BurstWrite_diff_col_row_bank_data(1,0,1,1,6);	// Row:1, Bank:1, Col:0, BurstSize:1, Data:6
      env2.mon2.BurstRead();
      if (intf.sdram_intf.sdr_ba != 1) begin
   	env2.mon2.sb.ErrCnt ++;
	$display("ERROR, incorrect programmed bank!!");
      end

      #1000;

      env2.drv2.BurstWrite_diff_col_row_bank_data(1,0,2,1,6);	// Row:1, Bank:2, Col:0, BurstSize:1, Data:6
      if (intf.sdram_intf.sdr_ba != 2) begin
   	env2.mon2.sb.ErrCnt ++;
	$display("ERROR, incorrect programmed bank!!");
      end

      #1000;

      env2.drv2.BurstWrite_diff_col_row_bank_data(1,0,3,1,6);	// Row:1, Bank:3, Col:0, BurstSize:1, Data:6
      env2.mon2.BurstRead();
      if (intf.sdram_intf.sdr_ba != 3) begin
   	env2.mon2.sb.ErrCnt ++;
	$display("ERROR, incorrect programmed bank!!");
      end
      
      env2.mon2.notExecTestCasesCount = env2.mon2.notExecTestCasesCount -1;
      
      $display("-------------------------------------- ");
      $display(" End-7 Four Bank feature               ");
      $display("-------------------------------------- ");
    end
  endtask   

  // Case:8 Configurable data width
  task tc8_configurable_data_width();
    logic[31:0] read_data;
    logic[31:0] expected_data;

    begin
      
      $display("----------------------------------------");
      $display(" Case-8 Configurable data width         ");
      $display("----------------------------------------");
 
      // 32'h80008080 -> 32bits:2147516544, 16bits:3289, 8bits:128

`ifdef SDR_32BIT
      expected_data = 2147516544;
`elsif SDR_16BIT
      expected_data = 3289;
`elsif SDR_8BIT
      expected_data = 128;
`endif

      env2.drv2.BurstWrite_diff_col_row_bank_data(,,,1,32'h80008080);
      env2.mon2.BurstReadRetVal(read_data);
      
      if (read_data != expected_data) begin
   	env2.mon2.sb.ErrCnt ++;
	$display("ERROR, incorrect programmed data!!");
        $display("OUT DATA: %d", read_data);
        $display("EXPECTED DATA: %d", expected_data);
      end

      #1000;

      env2.drv2.BurstWrite_diff_col_row_bank_data(,,,1,32'h00000008);
      env2.mon2.BurstReadRetVal(read_data);
      
      if (read_data != 8) begin
   	env2.mon2.sb.ErrCnt ++;
	$display("ERROR, incorrect programmed data!!");
        $display("OUT DATA: %d", read_data);
        $display("EXPECTED DATA: %d", 8);
      end
  
    end
  endtask 

endprogram
