class sdrcDrv;
    sdrcSB sb;
    virtual inft_sdrcntrl inft;

    function new(virtual inft_sdrcntrl inft,sdrcSB sb);
        $display("Creating SDRC Driver");
        this.sb = sb;
        this.inft = inft;

    endfunction

    task reset();
        begin
            sb.ErrCnt                        = 0;
            this.inft.wb_intf.wb_addr_i      = 0;
            this.inft.wb_intf.wb_dat_i       = 0;
            this.inft.wb_intf.wb_sel_i       = 4'h0;
            this.inft.wb_intf.wb_we_i        = 0;
            this.inft.wb_intf.wb_stb_i       = 0;
            this.inft.wb_intf.wb_cyc_i       = 0;
            this.inft.resetn                 = 1'h1;

            #100
            // Applying reset
            this.inft.resetn    = 1'h0;
           
            #10000;
            // Releasing reset
            this.inft.resetn    = 1'h1;
            
            #1000;
            wait(this.inft.sdram_intf.sdr_init_done == 1);
        end 
    endtask

    task BurstWrite();
        input [31:0] Address;  // Deprecated for second project
        input [7:0]  bl;       // Deprecated for second project
        int i;
        begin
            sb.dir.push_back(Address); // Deprecated for second project
            sb.burstLenght.push_back(bl);
            
            @ (negedge this.inft.sys_clk);
            $display("Write Address: %x, Burst Size: %d",Address,bl);
            for(i=0; i < bl; i++) begin
                this.inft.wb_intf.wb_stb_i        = 1;
                this.inft.wb_intf.wb_cyc_i        = 1;
                this.inft.wb_intf.wb_we_i         = 1;
                this.inft.wb_intf.wb_sel_i        = 4'b1111;
                this.inft.wb_intf.wb_addr_i       = Address[31:2]+i;
                this.inft.wb_intf.wb_dat_i        = $random & 32'hFFFFFFFF;
                sb.store.push_back(this.inft.wb_intf.wb_dat_i); // Deprecated for second project

                do begin
                    @ (posedge this.inft.sys_clk);
                end while(this.inft.wb_intf.wb_ack_o == 1'b0);
                    @ (negedge this.inft.sys_clk);
            
                $display("Status: Burst-No: %d  Write Address: %x  WriteData: %x ",i,this.inft.wb_intf.wb_addr_i,this.inft.wb_intf.wb_dat_i);
            end
            this.inft.wb_intf.wb_stb_i        = 0;
            this.inft.wb_intf.wb_cyc_i        = 0;
            this.inft.wb_intf.wb_we_i         = 'hx;
            this.inft.wb_intf.wb_sel_i        = 'hx;
            this.inft.wb_intf.wb_addr_i       = 'hx;
            this.inft.wb_intf.wb_dat_i        = 'hx;       
        end
        
    endtask

endclass
