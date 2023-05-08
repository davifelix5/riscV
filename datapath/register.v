module register #(parameter SIZE=64) (
  input wire[SIZE-1:0] IN,
  output reg[SIZE-1:0] OUT,
  input wire LOAD,
  input wire CLK
);

  always @(posedge CLK) begin
    if (LOAD)
      OUT <= IN;
  end

endmodule