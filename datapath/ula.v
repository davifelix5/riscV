module ula #(parameter SIZE = 64) (
  input[63:0] s1,
  input[63:0] s2,
  input[6:0] funct7,
  input[2:0] funct3,
  input[6:0] opcode,
  output[63:0] res,
  output wire overflow,
  output wire msb,
  output wire zero
);

  // PRECISA REFATORAR!

  wire cout, sub;

  assign overflow = cout;
  assign zero = ~| res;
  assign msb = res[SIZE-1];

  // Somador para calcular o resultado final
  adder #(.SIZE(SIZE)) adder (
    .X(s1),
    .Y(s2 ^ {SIZE{sub}}),
    .S(res),
    .Cin(sub),
    .Cout(cout)
  );

endmodule