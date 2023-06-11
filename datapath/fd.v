module fd 
#(  // Tamanho em bits dos barramentos
    parameter i_addr_bits = 6,
    parameter d_addr_bits = 6
)(
    input  clk, rst_n,                   // clock borda subida, reset assíncrono ativo baixo
    output [6:0] opcode,                    
    input  d_mem_we, rf_we,              // Habilita escrita na memória de dados e no banco de registradores
    input  [3:0] alu_cmd,                // ver abaixo
    output [3:0] alu_flags,
    input  alu_src,                      // 0: rf, 1: imm
            pc_src,                       // 0: +4, 1: +imm
            rf_src,                       // 0: alu, 1:d_mem
    output [i_addr_bits-1:0] i_mem_addr,
    input  [31:0]            i_mem_data,
    output [d_addr_bits-1:0] d_mem_addr,
    inout  [63:0]            d_mem_data

);

    wire[31:0] instruction;
    wire[63:0] extended_imm, rf_out1, rf_out2, ula, rf_din, alu_in2, pc;
    wire[4:0] rs1, rs2, rd;

    // Dados retirados da instrução
    assign opcode = i_mem_data[6:0];
    assign rs2 = i_mem_data[24:20];
    assign rs1 = i_mem_data[19:15];
    assign rd = i_mem_data[11:7];

    // Saída de dados
    assign d_mem_data = d_mem_we ? rf_out2 : 64'bz;

    // Endereços
    assign d_mem_addr = ula;
    assign i_mem_addr = pc[7:2];

    // Mutiplexadores do datapath
    assign rf_din = rf_src ? d_mem_data : ula;
    assign alu_in2 = alu_src ? extended_imm : rf_out2;

    immediate_decoder IMM_DECODER (
        .instruction(i_mem_data),
        .immediate(extended_imm)
    );

    program_counter PC (
        // Sinais de controle
        .clk(clk),
        .rst_n(rst_n),
        .pc_src(pc_src),
        .zero(alu_flags[0]),
        // Instrução
        .immediate(extended_imm),
        // Saidas
        .pc(pc)
    );

    regfile RF (
        // Seletor do registrador cujo valor estará na saída Da
        .rs1(rs1),
        // Seletor do registrador cujo valor estará na saída Db
        .rs2(rs2),
        // Caso esteja desativo, os loads não funcionam
        .WE(rf_we),
        // Entrada de dados a serem salvos no registrador
        .Din(rf_din),
        // Seletor do registrador em que a palavra Din será escrita
        .rd(rd),
        .CLK(clk),
        // Saídas de dados
        .D1(rf_out1),
        .D2(rf_out2)
    );

    ula ULA ( 
        // Operadores
        .s1(rf_out1),
        .s2(alu_in2),
        // Valores vindos da instrução
        .funct3(i_mem_data[14:12]),
        .funct7(i_mem_data[31:25]),
        .alu_cmd(alu_cmd),
        // Resultado da operação feita
        .res(ula),
        .alu_flags(alu_flags)
    );


endmodule