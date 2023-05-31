module program_counter_tb;

  reg clk, ld, rst;
  wire[63:0] addr;

  program_counter PC (
    .CLK(clk),
    .LOAD(ld),
    .RST(rst),
    .addr(addr)
  );

  initial begin
    $monitor("ADDR: %d", addr);
    ld = 1;
    clk = 0;
    rst = 1;
    #10
    rst = 0;
    #100
    $finish;
  end

  always #5 clk = ~clk;
endmodule