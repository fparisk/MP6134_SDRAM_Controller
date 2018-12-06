class sdrcMon;
    sdrcSB sb;
    virtual inft_sdrcntrl inft;
    int notExecTestCasesCount = 0;
    int testCasesCount = 0;
    
    function new(virtual inft_sdrcntrl inft,sdrcSB sb);
        $display("Creating SDRC Monitor");
        this.sb = sb;
        this.inft = inft; 
        // TO DO implementation

    endfunction
    
    task Check;
        begin
            if (this.notExecTestCasesCount==0 && sb.ErrCnt==0) begin
                $display("TEST EXECUTION PASSED!!!");
                $display("  TestCase execution count: %d", (this.testCasesCount - this.notExecTestCasesCount));
                $display("  Error count: %d", sb.ErrCnt);
            end else begin
                $display("TEST EXECUTION FAILED!!!");
                $display("  TestCase execution count: %d", (this.testCasesCount - this.notExecTestCasesCount));
                $display("  Error count: %d", sb.ErrCnt);
            end
        end
    endtask

    task BurstRead();
    reg [31:0] Address; 
    reg [7:0]  bl;
        // TO DO implementation

    reg [31:0]   exp_data; 
    int unsigned   exp_data;
    int j;
    begin

        Address = sb.dir.pop_front(); 
        bl      = sb.burstLenght.pop_front(); 
        @ (negedge this.inft.sys_clk);

        for(j=0; j < bl; j++) begin
            Address = sb.dir.pop_front();
            this.inft.wb_intf.wb_stb_i        = 1;
            this.inft.wb_intf.wb_cyc_i        = 1;
            this.inft.wb_intf.wb_we_i         = 0;
            this.inft.wb_intf.wb_addr_i       = Address[31:2]+j; 
            
            do begin
                @ (posedge this.inft.sys_clk);
            end while(this.inft.wb_intf.wb_ack_o == 1'b0);
            if(this.inft.wb_intf.wb_dat_o !== exp_data) begin
                $display("READ ERROR: Burst-No: %d Addr: %x Rxp: %x Exd: %x",j,this.inft.wb_intf.wb_addr_i,this.inft.wb_intf.wb_dat_o,exp_data);
                sb.ErrCnt = sb.ErrCnt+1;
            end else begin
                $display("READ STATUS: Burst-No: %d Addr: %x Rxd: %x",j,this.inft.wb_intf.wb_addr_i,this.inft.wb_intf.wb_dat_o);
            end 
            @ (negedge this.inft.sdram_intf.sdram_clk);
        end
        this.inft.wb_intf.wb_stb_i        = 0;
        this.inft.wb_intf.wb_cyc_i        = 0;
        this.inft.wb_intf.wb_we_i         = 'hx;
        this.inft.wb_intf.wb_addr_i       = 'hx;

    end
    endtask //

endclass
