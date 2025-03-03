module tb;

  reg clk, rst, Wr_Rd, valid;
  reg [7:0] WDATA;
  reg [3:0] ADDR;
  wire [7:0] RDATA;
  wire ready;
  integer i;
  reg [7:0] mem_test [0:15]; // Test memory to verify read values

  // Instantiate DUT
  Single_Port_RAM DUT (
    .clk(clk),
    .rst(rst),
    .Wr_Rd(Wr_Rd),
    .valid(valid),
    .ADDR(ADDR),
    .WDATA(WDATA),
    .RDATA(RDATA),
    .ready(ready)
  );

  // Clock Generation (10ns period)
  initial begin
    clk = 0;
    forever #5 clk = ~clk;
  end

  // Test Procedure
  initial begin
    $monitor("Time = %3t, clk=%b, rst=%b, Wr_Rd=%b, valid=%b, ADDR=%d, WDATA=%h, RDATA=%h, ready=%b",
             $time, clk, rst, Wr_Rd, valid, ADDR, WDATA, RDATA, ready);

    // Reset sequence
    valid = 0;
    rst = 0;
    #20 rst = 1; // Hold reset for 20ns

    // Write Data to Memory
    valid = 1;
    Wr_Rd = 1; // Write mode
    for (i = 0; i < 16; i = i + 1) begin
      @(posedge clk);
      ADDR = i;
      WDATA = $random; // Random data
      mem_test[i] = WDATA; // Store written data for later verification
    end

    // Read Data from Memory
    Wr_Rd = 0; // Read mode
    for (i = 0; i < 16; i = i + 1) begin
      @(posedge clk);
      ADDR = i;
      #1; // Small delay to allow read
      if (RDATA !== mem_test[i]) // Check data integrity
        $display("ERROR at ADDR %d: Expected %h, Got %h", ADDR, mem_test[i], RDATA);
    end

    #20 $finish; // End simulation
  end

  // Waveform Dump
  initial begin
    $dumpfile("wave.vcd");
    $dumpvars(0, tb);
  end

endmodule
