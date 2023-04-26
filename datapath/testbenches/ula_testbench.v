`include "datapath/ula.v"

module ula_testbench;

  reg[63:0] s1, s2;
  reg sub;
  wire[63:0] res;

  ula UUT (
  .s1(s1),
  .s2(s2),
  .sub(sub),
  .res(res)
  );

  initial begin
    s1 = 64'b000111000010; // 450
    s2 = 64'b00101111; // 47
    sub = 0;
    #50
    $write("%d + %d = %d", s1, s2, res);
    if (res == s1 + s2)
      $write("[PASSED]\n");
    else
      $write("[WRONG!]\n");
    s1 = 64'b000111000010; // 450
    s2 = 64'b00101111; // 47
    sub = 1;
    #50
    $write("%d - %d = %d", s1, s2, res);
    if (res == s1 - s2)
      $write("[PASSED]\n");
    else
      $write("[WRONG!]\n");
    #50;

  end

endmodule