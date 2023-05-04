module REG_rst #(parameter SIZE=64) (
  input wire[SIZE-1:0] IN,
  output reg[SIZE-1:0] OUT,
  input RST,
  input wire LOAD,
  input wire CLK
);

  always @(posedge CLK or posedge RST) begin
    if (RST)
      OUT <= {SIZE{1'b0}};
    else if (LOAD)
      OUT <= IN;
  end

endmodule