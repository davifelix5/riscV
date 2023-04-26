`include "datapath/somador.v"

module ula (
  input wire[63:0] s1,
  input wire[63:0] s2,
  input wire sub,
  output wire[63:0] res
);

  wire[63:0] converted;
  wire[63:0] final_s2;

  assign final_s2 = sub ? converted : s2;

  SOMADOR #(.SIZE(64)) SOMADOR_CONVERTER (
    .X(~s2),
    .Y(64'b1),
    .S(converted),
    .Cin(1'b0)
  );

  SOMADOR #(.SIZE(64)) SOMADOR_FINAL (
    .X(s1),
    .Y(final_s2),
    .S(res),
    .Cin(1'b0)
  );

endmodule