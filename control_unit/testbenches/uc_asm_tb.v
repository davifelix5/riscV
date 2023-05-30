`include "control_unit/uc_asm.v"

module uc_asm_tb;
  
  wire WE_RF, WE_MEM, ULA_din2_sel, load_pc, load_ir, pc_next_sel, pc_adder_sel;
  wire[1:0] RF_din_sel;
  reg[6:0] opcode;
  reg clk, reset;

  uc_asm UUT (
    .reset(reset),
    .clk(clk),
    .opcode(opcode),
    .WE_RF(WE_RF),
    .WE_MEM(WE_MEM),
    .RF_din_sel(RF_din_sel),
    .ULA_din2_sel(ULA_din2_sel),
    .load_pc(load_pc),
    .load_ir(load_ir),
    .pc_next_sel(pc_next_sel),
    .pc_adder_sel(pc_adder_sel)
  );

  initial begin
    $dumpfile("control_unit/testbenches/waves/uc_asm/waveforms3.vcd");
    $dumpvars(0, uc_asm_tb);
    clk = 0;
    reset = 1;
    #10
    reset = 0;

    opcode = 7'b0110011;
    #20
    opcode = 7'b0010011;
    
    #100
    $finish;
  end

  always #5 clk = ~clk;

endmodule