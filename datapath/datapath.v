`include "datapath/instruction_memory.v"
`include "datapath/program_counter.v"
`include "datapath/datamemory.v"
`include "datapath/regfile.v"
`include "datapath/ula.v"
`include "datapath/decoder2to4.v"
`include "datapath/decoder3to8.v"
`include "datapath/register.v"
`include "datapath/decoder5to32.v"
`include "datapath/adder.v"
`include "datapath/register_negedge_with_reset.v"

module datapath(
    input wire sub, // entra nas functs
    input WE_RF,
    input WE_MEM,
    input wire RF_din_sel,
    input wire ULA_din2_sel,
    input wire load_pc,
    input wire reset_pc,
    input wire CLK,
    input wire pc_next_sel
);

    wire[31:0] instruction_mem, instruction;
    wire[63:0] im_addr, extended_imm, DM_in, DM_out, Dout_rs1, Dout_rs2, ula, RF_Din, ULA_Din2;
    wire[11:0] imm;
    wire[2:0] opcode;
    wire[4:0] rs1, rs2, rd, DM_ADDR;
    wire EQ, GT_SN, LT_SN, GT_UN, LT_UN; // FLAGS

    // Dados retirados da instrução
    assign imm = instruction[6:0] == 7'b0100011 ? {instruction[31:25], instruction[11:7]} : (instruction[6:0] == 7'b1100011 ? {instruction[31], instruction[7], instruction[30:25], instruction[11:8]} : instruction[31:20]);
    assign extended_imm = {{52{imm[11]}}, imm};
    assign rs2 = instruction[24:20];
    assign rs1 = instruction[19:15];
    assign rd = instruction[11:7];

    // Mutiplexadores do datapath
    assign RF_Din = RF_din_sel ? ula : DM_out;
    assign ULA_Din2 = ULA_din2_sel ? extended_imm : Dout_rs2;

    program_counter PC (
        .CLK(CLK),
        .LOAD(load_pc),
        .addr(im_addr),
        .RST(reset_pc),
        .immediate(extended_imm),
        .opcode(instruction[6:0]),
        .func(instruction[14:12]),
        .EQ(EQ),
        .LT_SN(LT_SN),
        .LT_UN(LT_UN),
        .GT_SN(GT_SN),
        .GT_UN(GT_UN)
    );

    datamemory DM (
        // Endereço da memória para ler
        .ADDR(ula[4:0]), 
        // Write-Enable da memória
        .WE(WE_MEM), 
        // O valor do registrador Ra é salvo na memória na borda de subida do clock se WE é 1
        .D_in(Dout_rs2),
        // Saída de dados da memória
        .D_out(DM_out), 
        .CLK(CLK)
    );

    regfile RF (
        // Seletor do registrador cujo valor estará na saída Da
        .Ra(rs1),
        // Seletor do registrador cujo valor estará na saída Db
        .Rb(rs2),
        // Caso esteja desativo, os loads não funcionam
        .WE(WE_RF),
        // Entrada de dados a serem salvos no registrador
        .Din(RF_Din),
        // Seletor do registrador em que a palavra Din será escrita
        .Rw(rd),
        .CLK(CLK),
        // Saídas de dados
        .Da(Dout_rs1),
        .Db(Dout_rs2)
    );

    // Somador para somar o endereço de origem da memória com o offset fornecido
    ula ULA ( 
        .s1(Dout_rs1),
        .s2(ULA_Din2),
        .sub(sub),
        .res(ula),
        .EQ(EQ),
        .GT_SN(GT_SN),
        .LT_SN(LT_SN),
        .GT_UN(GT_UN),
        .LT_UN(LT_UN)
    );

    instruction_memory IM (
        .ADDR({2'b0,im_addr[63:2]}),
        .OUTPUT(instruction_mem)
    );

    register #(.SIZE(32)) IR (
        .CLK(CLK),
        .IN(instruction_mem),
        .OUT(instruction),
        .LOAD(1'b1)
    );

endmodule