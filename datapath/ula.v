module ula #(parameter SIZE = 64) (
  input[63:0] s1,
  input[63:0] s2,
  input[6:0] funct7,
  input[2:0] funct3,
  input[3:0] alu_cmd,
  output reg [63:0] res,
  output [3:0] alu_flags
);

  wire[63:0] sum;
  wire cout, sub;
  wire[63:0] out_and, out_or, out_xor;

  assign sub = (alu_cmd == 4'b0011) | (alu_cmd == 4'b0 & ~|funct3 & funct7[5]);

  // Flags
  assign overflow = cout;
  assign zero = ~| res;
  assign msb = res[SIZE-1];

  assign alu_flags = {1'b0, overflow, msb, zero};

  // Operações lógicas
  assign out_and = s1 & s2;
  assign out_or = s1 | s2;
  assign out_xor = s1 ^ s2;

  // Somador para calcular soma e diferença
  adder #(.SIZE(SIZE)) adder (
    .X(s1),
    .Y(s2 ^ {SIZE{sub}}),
    .S(sum),
    .Cin(sub),
    .Cout(cout)
  );
  
  // Seleção da saída
  always @(*) begin
    case (funct3)
      3'b000: res = sum;
      3'b100: res = out_xor;
      3'b110: res = out_or;
      3'b111: res = out_and;
      default: res = sum;
    endcase
  end

endmodule