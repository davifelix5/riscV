`include "datapath/decoder5to32.v"

module decoder5to32_testbench;

  reg[4:0] IN;
  wire[31:0] OUT;
  reg EN;

  decoder5to32 UUT (
    .IN(IN),
    .EN(EN),
    .OUT(OUT)
  );

  initial begin
    $monitor("%b %b", IN, OUT);
    EN = 1;
    IN = 5'd9;
  end

endmodule