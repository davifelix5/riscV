`include "datapath/datapath_with_uc.v"
`include "control_unit/uc_asm.v"

module add_sub_with_uc (
  input wire clk,
  input wire reset
);

  wire[63:0] pc, data_in, data_out;
  wire[11:0] mem_address;
  wire WE_RF, WE_MEM, ULA_din2_sel, load_pc, load_ir, pc_next_sel, pc_adder_sel;
  wire[1:0] RF_din_sel;
  wire[6:0] opcode;
  wire[31:0] im_out;

  uc_asm UC (
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

  datapath_with_uc DP (
    .WE_RF(WE_RF),
    .WE_MEM(WE_MEM),
    .RF_din_sel(RF_din_sel),
    .ULA_din2_sel(ULA_din2_sel),
    .load_pc(load_pc),
    .load_ir(load_ir),
    .reset(reset),
    .CLK(clk),
    .pc_next_sel(pc_next_sel),
    .pc_adder_sel(pc_adder_sel),
    .data_in({32'b0, im_out}),
    .data_out(data_out),
    .pc(pc),
    .mem_address(mem_address),
    .opcode(opcode)
  );

  // Não será usada por enquanto
  datamemory #(.SIZE(64), .N(4096)) DM (
    .ADDR(mem_address),
    .WE(WE_MEM),
    .D_in(data_out),
    .D_out(data_in),
    .CLK(clk)
  );

  // Por enquanto, endereço entra direto, pois a memória de dados não será usada
  instruction_memory IM(
    .ADDR({2'b0, pc[63:2]}),
    .OUTPUT(im_out)
  );
  
endmodule