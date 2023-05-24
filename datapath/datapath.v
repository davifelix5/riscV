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
`include "datapath/immediate_decoder.v"

module datapath(
    input wire sub, // entra nas functs
    input WE_RF,
    input WE_MEM,
    input wire[1:0] RF_din_sel,
    input wire ULA_din2_sel,
    input wire load_pc,
    input wire reset_pc,
    input wire CLK,
    input wire pc_next_sel,
    input wire pc_adder_sel
);

    wire[31:0] instruction_mem, instruction;
    wire[63:0] extended_imm, DM_in, DM_out, Dout_rs1, Dout_rs2, ula, RF_Din, ULA_Din2, im_addr, pc_to_store, last_pc;
    wire[2:0] opcode;
    wire[4:0] rs1, rs2, rd, DM_ADDR;
    wire EQ, GT_SN, LT_SN, GT_UN, LT_UN; // FLAGS

    // Registrador para salvar o que seria o próximo PC depois de um jump
    register last_pc_reg (.IN(pc_to_store), .LOAD(1'b1), .CLK(CLK), .OUT(last_pc));

    // Dados retirados da instrução
    assign rs2 = instruction[24:20];
    assign rs1 = instruction[19:15];
    assign rd = instruction[11:7];

    // Mutiplexadores do datapath
    assign RF_Din = RF_din_sel[1] ? last_pc : (RF_din_sel[0] ? ula : DM_out);
    assign ULA_Din2 = ULA_din2_sel ? extended_imm : Dout_rs2;

    immediate_decoder IMM_DECODER (
        .instruction(instruction),
        .immediate(extended_imm)
    );

    program_counter PC (
        // Sinais de controle
        .CLK(CLK),
        .LOAD(load_pc),
        .RST(reset_pc),
        .pc_adder_sel(pc_adder_sel),
        .pc_next_sel(pc_next_sel),
        // Instrução
        .opcode(instruction[6:0]),
        .func(instruction[14:12]),
        .immediate(extended_imm),
        // Saidas
        .addr(im_addr),
        .pc_to_store(pc_to_store),
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
        // Realizar ou não subtração
        .sub(sub),
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
    register #(.SIZE(32)) IR (
        .CLK(CLK),
        .IN(instruction_mem),
        .OUT(instruction),
        .LOAD(1'b1)
    );

endmodule