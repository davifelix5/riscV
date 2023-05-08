`include "datapath/decoder5to32.v"
`include "datapath/decoder2to4.v"
`include "datapath/decoder3to8.v"

module decoder5to32_tb;

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
    IN = 5'd0;
    #50
    IN = 5'd1;
    #50
    IN = 5'd2;
    #50
    IN = 5'd3;
    #50
    IN = 5'd4;
    #50
    IN = 5'd5;
    #50
    IN = 5'd6;
  end

endmodule