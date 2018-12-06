program testcase(inft_sdrcntrl intf);

  // sdrcEnv env = new(intf); // Deprecated for second project.
  sdrcEnv2 env2 = new(intf);
  int k;
  reg [31:0] StartAddr;
  
  initial 
  begin
    // set test execution count
    env2.mon2.testCasesCount = 9;
    env2.mon2.notExecTestCasesCount = env2.mon2.testCasesCount;

    // CAS Latency case 1 (invalid value)
    // reset
    env2.drv2.ModifyModeRegister(13'h013);
    env2.drv2.reset();
    
    // Tests to execute
    tc1_single_read();

    // CAS Latency case 2 (2 cycles)
    // reset
    env2.drv2.ModifyModeRegister(13'h023);
    env2.drv2.reset();
    
    // Tests to execute
    tc1_single_read();
    
    // CAS Latency case 3 (3 cycles)
    // reset
    env2.drv2.ModifyModeRegister(13'h033);
    env2.drv2.reset();

    // Tests to execute
    tc1_single_read();
    tc2_x2_read();
    tc3_page_cross_over();
    tc5_x24_Write_and_Read_diff_row_bank();
    tc4_x4_Write_Read();
    tc6_write_read_different_order();
    tc7_prog_col();

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

  // Case:7 Diff row, bank and column
  task tc7_prog_col();
    begin
      
      $display("----------------------------------------");
      $display(" Case-7 Diff row, bank and column        ");
      $display("----------------------------------------");

      env2.drv2.BurstWrite_diff_col_row_bank(,,22);  
      env2.drv2.BurstWrite_diff_col_row_bank(,,240);  
      env2.drv2.BurstWrite_diff_col_row_bank(,,256);  

      env2.mon2.BurstRead();  
      env2.mon2.BurstRead();  
      env2.mon2.BurstRead();
      
      env2.mon2.notExecTestCasesCount = env2.mon2.notExecTestCasesCount -1;
      
      $display("-------------------------------------- ");
      $display(" End-7 Diff row, bank and column");
      $display("-------------------------------------- ");
    end
  endtask   

endprogram
