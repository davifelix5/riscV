`include "datapath/instruction_memory.v"
`include "datapath/program_counter.v"
`include "datapath/datapath.v"
`include "datapath/datamemory.v"
`include "datapath/regfile.v"
`include "datapath/ula.v"
`include "datapath/decoder2to4.v"
`include "datapath/decoder3to8.v"
`include "datapath/register.v"
`include "datapath/decoder5to32.v"
`include "datapath/adder.v"
`include "datapath/register_with_reset.v"
`include "datapath/instruction_register.v"

module datapath_with_instructions(
    input wire sub, // entra nas functs
    input WE_RF,
    input WE_MEM,
    input wire RF_din_sel,
    input wire ULA_din2_sel,
    input wire load_pc,
    input wire reset_pc,
    input wire CLK
);

    wire[31:0] instruction_mem, instruction;
    wire[63:0] im_addr;
    wire[11:0] imm, extended_imm;
    wire[2:0] opcode;
    wire[4:0] rs1, rs2, rd;

    assign imm = instruction[6:0] == 7'b0100011 ? {instruction[31:25], instruction[11:7]} : instruction[31:20];
    assign extended_imm = {{52{imm[11]}}, imm};
    assign rs2 = instruction[24:20];
    assign rs1 = instruction[19:15];
    assign rd = instruction[11:7];

    program_counter PC (
        .CLK(CLK),
        .LOAD(load_pc),
        .addr(im_addr),
        .RST(reset_pc),
        .immediate(extended_imm),
        .pc_next_sel(1'b0)
    );

    datapath DP (
        .rs1(rs1),
        .rs2(rs2),
        .rd(rd),
        .immediate(extended_imm),
        .sub(sub), // entra nas functs
        .WE_RF(WE_RF),
        .WE_MEM(WE_MEM),
        .RF_din_sel(RF_din_sel),
        .ULA_din2_sel(ULA_din2_sel),
        .CLK(CLK)
    );

    instruction_memory IM (
        .ADDR(im_addr),
        .OUTPUT(instruction_mem)
    );

    instruction_register IR (
        .in(instruction_mem),
        .out(instruction),
        .clk(CLK)
    );

endmodule