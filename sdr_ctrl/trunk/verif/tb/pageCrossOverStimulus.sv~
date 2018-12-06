class pageCrossOverStimulus;

  function new();
        $display("Creating page cross-over stimulus");
  endfunction

  // non random signals
  logic [1:0]  bank;
  logic [7:0]  column_ms_byte;
  logic [7:0]  column;

  // random data types/signals
  randc logic [11:0] row;
  rand  logic [7:0]  column_ls_byte;
  rand  logic [7:0]  burst_size;

  // constraints
  constraint column_less_significant_byte_range  { column_ls_byte inside {[10:13]}; }       
  constraint burst_range { burst_size inside {[8:15]}; }        

  //assignations
  task generatePageCrossOverAddress();
    begin
      this.bank = 2'b11;
      this.column_ms_byte = 8'hF0;
      this.column = this.column_ms_byte | this.column_ls_byte;
    end
  endtask
endclass