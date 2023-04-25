`include "datapath/decoder.v"

module decoder_testbench;

  reg[4:0] IN;
  wire[31:0] OUT;
  reg EN;

  LOAD_DECODER UUT (
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