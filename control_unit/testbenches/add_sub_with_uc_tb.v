module add_sub_with_uc_tb;

  reg reset, clk;

  add_sub_with_uc UUT (
    .clk(clk),
    .reset(reset)
  );

  initial begin
    $dumpfile("control_unit/testbenches/waves/add_sub_uc/waveforms3.vcd");
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