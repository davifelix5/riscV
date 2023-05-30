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
`include "datapath/register_with_reset.v"
`include "datapath/pc_register_with_preset.v"
`include "datapath/immediate_decoder.v"

module datapath(
    input WE_RF,
    input WE_MEM,
    input wire[1:0] RF_din_sel,
    input wire ULA_din2_sel,
    input wire load_pc,
    input wire load_ir,
    input wire reset,
    input wire CLK,
    input wire pc_next_sel,
    input wire pc_adder_sel
);

    wire[31:0] instruction_mem, instruction;
    wire[63:0] extended_imm, DM_in, DM_out, Dout_rs1, Dout_rs2, ula, RF_Din, ULA_Din2, im_addr, pc_primary_adder, pc_secondary_adder, last_pc_primary;
    wire[6:0] opcode;
    wire[4:0] rs1, rs2, rd, DM_ADDR;
    wire EQ, GT_SN, LT_SN, GT_UN, LT_UN; // FLAGS

    // Dados retirados da instrução
    assign opcode = instruction[6:0];
    assign rs2 = instruction[24:20];
    assign rs1 = instruction[19:15];
    assign rd = instruction[11:7];

    // Mutiplexadores do datapath
    assign RF_Din = RF_din_sel[1] ? (RF_din_sel[0] ? pc_secondary_adder : pc_primary_adder) : (RF_din_sel[0] ? ula : DM_out);
    assign ULA_Din2 = ULA_din2_sel ? extended_imm : Dout_rs2;

    immediate_decoder IMM_DECODER (
        .instruction(instruction),
        .immediate(extended_imm)
    );

    program_counter PC (
        // Sinais de controle
        .CLK(CLK),
        .LOAD(load_pc),
        .RST(reset),
        .pc_adder_sel(pc_adder_sel),
        .pc_next_sel(pc_next_sel),
        // Instrução
        .opcode(opcode),
        .func(instruction[14:12]),
        .immediate(extended_imm),
        // Saidas
        .pc_next(im_addr),
        .primary_adder_res(pc_primary_adder),
        .secondary_adder_res(pc_secondary_adder),
        // Valor do regfile
        .Dout_rs1(Dout_rs1),
        // Flags
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
        .rs1(rs1),
        // Seletor do registrador cujo valor estará na saída Db
        .rs2(rs2),
        // Caso esteja desativo, os loads não funcionam
        .WE(WE_RF),
        // Entrada de dados a serem salvos no registrador
        .Din(RF_Din),
        // Seletor do registrador em que a palavra Din será escrita
        .rd(rd),
        .CLK(CLK),
        // Saídas de dados
        .D1(Dout_rs1),
        .D2(Dout_rs2)
    );

    ula ULA ( 
        // Operadores
        .s1(Dout_rs1),
        .s2(ULA_Din2),
        // Valores vindos da instrução
        .funct3(instruction[14:12]),
        .funct7(instruction[31:25]),
        .opcode(opcode),
        // Resultado da operação feita
        .res(ula),
        // Flags
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

    // Instruction register
    register_with_reset #(.SIZE(32)) IR (
        .CLK(CLK),
        .RST(reset),
        .IN(instruction_mem),
        .OUT(instruction),
        .LOAD(load_ir)
    );

endmodule