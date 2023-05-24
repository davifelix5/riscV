`include "datapath/immediate_decoder.v"

module immediate_decoder_tb;

  reg[31:0] inst_tb;
  wire[63:0] imm;

  wire[63:0] signed_imm;

  assign signed_imm = $signed(imm);

  immediate_decoder UUT (
    .instruction(inst_tb),
    .immediate(imm)
  );

  initial begin
    $monitor("%d %b", signed_imm, signed_imm);
    
    #50
    inst_tb = {1'b1, 6'b111111, 5'd0, 5'd0, 3'b000, 4'b0110, 1'b1, 7'b1100011}; // beq x1, x2, -20
    #50
    inst_tb = {12'd50, 5'd4, 3'b000, 5'd5, 7'b0010011}; // addi x5, x4, 50
    #50
    inst_tb = {7'b0, 5'd4, 5'd0, 3'b010, 5'b10010, 7'b0100011}; // st x4, 18(x0)
    #50
    inst_tb = 32'b00111010010000000000000011101111;
    #50;
    inst_tb = 32'b00000000100000000000000001100111;
    #50;
    inst_tb = 32'b00000000000000000001001010010111;
    #50;
  end


endmodule