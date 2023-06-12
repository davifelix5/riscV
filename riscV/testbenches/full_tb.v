module full_tb;

  reg rst_n, clk;

  full UUT (
    .clk(clk),
    .rst_n(rst_n)
  );

  initial begin
    $dumpfile("riscV/testbenches/waves/full/waveforms3.vcd");
    $dumpvars(0, UUT);
    clk = 0;
    rst_n = 0;
    #10
    rst_n = 1;
    #3000
    $finish;

  end

  always #5 clk = ~clk;

endmodule