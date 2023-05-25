module pc_register_with_preset (
  input wire[63:0] IN,
  output reg[63:0] OUT,
  input PST,
  input wire LOAD,
  input wire CLK
);

  always @(posedge CLK or posedge PST) begin
    if (PST)
      OUT <= {{62{1'b1}}, 2'b00}; // -4
    else if (LOAD)
      OUT <= IN;
  end

endmodule