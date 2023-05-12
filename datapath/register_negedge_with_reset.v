module register_negedge_with_reset #(parameter SIZE=64) (
  input wire[SIZE-1:0] IN,
  output reg[SIZE-1:0] OUT,
  input RST,
  input wire LOAD,
  input wire CLK
);

  always @(negedge CLK or negedge RST) begin
    if (~RST)
      OUT <= {SIZE{1'b0}};
    else if (LOAD)
      OUT <= IN;
  end

endmodule