module full_tb;

  reg reset, clk;

  full UUT (
    .clk(clk),
    .reset(reset)
  );

  initial begin
    $dumpfile("riscV/testbenches/waves/full/waveforms3.vcd");
    $dumpvars(0, UUT);
    clk = 0;
    reset = 1;
    #10
    reset = 0;
    #1000
    $finish;

  end

  always #5 clk = ~clk;

endmodule