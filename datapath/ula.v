`include "datapath/somador.v"

module ula #(parameter SIZE = 64) (
  input wire[63:0] s1,
  input wire[63:0] s2,
  input wire sub,
  output wire[63:0] res
);

  // Somador para calcular o resultado final
  SOMADOR #(.SIZE(SIZE)) SOMADOR_FINAL (
    .X(s1),
    .Y(s2 ^ {SIZE{sub}}),
    .S(res),
    .Cin(sub)
  );

endmodule