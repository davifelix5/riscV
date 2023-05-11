`include "datapath/adder.v"
`include "datapath/ula.v"

module flags_tb;

  reg[63:0] s1, s2;
  wire[63:0] res;

  ula UUT (
  .s1(s1),
  .s2(s2),
  .sub(1'b1),
  .res(res)
  );

  initial begin
    $dumpfile("datapath/testbenches/waves/flags/waves.vcd");
    $dumpvars(0, flags_tb);
    // Signed
    s1 = 64'd1;
    s2 = -64'd45;
    #50

    s1 = 64'd10000;
    s2 = 64'd5461;
    #50;

    s1 = -64'd10000;
    s2 = -64'd4197;
    #50;

    s1 = 64'd9223372036854775808;
    s2 = 64'd9223372036854775800;
    #50;

    s1 = 64'd9223372036854775800;
    s2 = 64'd9223372036854775808;
    #50;

    s1 = -64'd9223372036854775808; //-2^63
    s2 = 64'd9223372036854775807; // 2^63 - 1
    #50

    s1 = -64'd2; //-2^63
    s2 = -64'd2; // 2^63 - 1
    #50

    s1 = 64'd4; //-2^63
    s2 = 64'd4; // 2^63 - 1
    #50

    // Unsigned

    s1 = 64'd12873481;
    s2 = 64'd18446744073709551615; // 2^64 - 1
    #50;

    s2 = 64'd12873481;
    s1 = 64'd18446744073709551615; // 2^64 - 1
    #50;

    s1 = 64'd30;
    s2 = 64'd29;
    #50;

    s1 = 64'd29;
    s2 = 64'd30;
    #50;

    s1 = 64'd18446744073709551615;
    s2 = 64'd18446744073709551615; // 2^64 - 1
    #50;

  end

endmodule