module immediate_decoder(
  input wire[31:0] instruction,
  output reg[63:0] immediate
);

  always @(*) begin
    case (instruction[6:0]) // opcode
      // S-type
      7'b0100011: immediate = {{52{instruction[31]}}, instruction[31:25], instruction[11:7]}; 
      // B-type
      7'b1100011: immediate = {{52{instruction[31]}}, instruction[7], instruction[30:25], instruction[11:8], 1'b0};
      // I-type
      default: immediate = instruction[31:20];
    endcase
  end

endmodule