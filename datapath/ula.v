module ula #(parameter SIZE = 64) (
  input wire[63:0] s1,
  input wire[63:0] s2,
  input wire sub,
  output wire[63:0] res,
  output wire EQ,
  output wire GT_SN,
  output wire LT_SN,
  output wire GT_UN,
  output wire LT_UN
);

  wire cout;

  assign EQ = ~| res;
  assign GT_SN = ~EQ & ~LT_SN;
  assign LT_SN = (s1[63] ^ s2[63]) ? s1[63]: res[63];
  assign LT_UN = ~GT_UN & ~EQ;
  assign GT_UN = cout & ~EQ;

  // Somador para calcular o resultado final
  adder #(.SIZE(SIZE)) adder (
    .X(s1),
    .Y(s2 ^ {SIZE{sub}}),
    .S(res),
    .Cin(sub),
    .Cout(cout)
  );

endmodule