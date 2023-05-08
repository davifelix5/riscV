`include "datapath/register.v"

module register_tb;

  reg[31:0] IN_tb;
  wire[31:0] OUT_tb;
  reg CLK_tb, LOAD_tb;

  register #(.SIZE(32)) UUT (
    .IN(IN_tb),
    .OUT(OUT_tb),
    .LOAD(LOAD_tb),
    .CLK(CLK_tb)
  );

  initial begin
    $monitor("LOAD:%b ; IN:%d ; OUT:%d; CLK = %b", LOAD_tb, IN_tb, OUT_tb, CLK_tb);
    CLK_tb = 0;
    LOAD_tb = 0;
    #10;
    IN_tb = 32'd45;
    LOAD_tb = 1;
    #10
    LOAD_tb = 0;
    IN_tb = 32'd450;
    #15;
    $finish;
  end

  always #5 CLK_tb = ~CLK_tb;

endmodule