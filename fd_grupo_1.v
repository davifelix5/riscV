/**

INSTRUÇÃO PARA RODAR (IMPORTANTE):
  É necessário enviar o sinal de reset para o fluxo de dados no começo do teste a fim
de inicilizar o valor do PC.

OBS: o reset é ativo baixo, então deve ser enviado rst_n = 0 e, depois, rst_n = 1.
**/

module adder1bit (
    input wire X,
    input wire Y,
    input wire Cin,
    output wire S,
    output wire Cout
);
    wire xor1;

    assign xor1 = X ^ Y;
    assign S = xor1 ^ Cin;
    assign Cout = (X & Y) | (Cin & xor1);

endmodule

module adder #(parameter SIZE=32) (
    input wire[SIZE-1:0] X,
    input wire[SIZE-1:0] Y,
    input wire Cin,
    output wire[SIZE-1:0] S,
    output wire Cout
);
    wire[SIZE:0] cins;
    genvar i;

    assign cins[0] = Cin;

    generate
      for (i=0; i < SIZE; i = i + 1) begin: adders
        adder1bit SOMA (.X(X[i]), .Y(Y[i]), .S(S[i]), .Cin(cins[i]), .Cout(cins[i+1]));
      end
    endgenerate

    assign Cout = cins[SIZE];

endmodule

module decoder2to4 (
  input wire[1:0] IN,
  input wire EN,
  output wire[3:0] OUT
);

  assign OUT[0] = EN & ~IN[1] & ~IN[0];
  assign OUT[1] = EN & ~IN[1] & IN[0];
  assign OUT[2] = EN & IN[1] & ~IN[0];
  assign OUT[3] = EN & IN[1] & IN[0];

endmodule

module decoder3to8 (
  input wire[2:0] IN,
  input wire EN,
  output wire[7:0] OUT
);

  assign OUT[0] = EN & ~IN[2] & ~IN[1] & ~IN[0];
  assign OUT[1] = EN & ~IN[2] & ~IN[1] & IN[0];
  assign OUT[2] = EN & ~IN[2] & IN[1] & ~IN[0];
  assign OUT[3] = EN & ~IN[2] & IN[1] & IN[0];
  assign OUT[4] = EN & IN[2] & ~IN[1] & ~IN[0];
  assign OUT[5] = EN & IN[2] & ~IN[1] & IN[0];
  assign OUT[6] = EN & IN[2] & IN[1] & ~IN[0];
  assign OUT[7] = EN & IN[2] & IN[1] & IN[0];

endmodule

module decoder5to32 (
    input wire EN,
    input wire[4:0] IN,
    output wire[31:0] OUT
);

  wire[3:0] EN1;

  decoder2to4 DEC2_4 (
    .IN(IN[4:3]),
    .OUT(EN1),
    .EN(EN)
  );

  decoder3to8 DEC3_8__1 (
    .IN(IN[2:0]),
    .OUT(OUT[31:24]),
    .EN(EN1[3])
  );

  decoder3to8 DEC3_8__2 (
    .IN(IN[2:0]),
    .OUT(OUT[23:16]),
    .EN(EN1[2])
  );

  decoder3to8 DEC3_8__3 (
    .IN(IN[2:0]),
    .OUT(OUT[15:8]),
    .EN(EN1[1])
  );

  decoder3to8 DEC3_8__4 (
    .IN(IN[2:0]),
    .OUT(OUT[7:0]),
    .EN(EN1[0])
  );
  
endmodule

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
      // J-type
      7'b1101111: immediate = {{44{instruction[31]}}, instruction[19:12], instruction[20], instruction[30:21], 1'b0};
      // U-type
      7'b0010111: immediate = {{32{instruction[31]}}, instruction[31:12], 12'b0};
      // I-type
      default: immediate = {{52{instruction[31]}}, instruction[31:20]};
    endcase
  end

endmodule

module pc_counter (
    input wire clk_in,
    input wire rst_n,
    output wire clk_out
);

reg [1:0] count;

always @(posedge clk_in or negedge rst_n) begin
    if (!rst_n) count <= 2'b11;
    else count <= count + 2'b01;
end

assign clk_out = count[1];

endmodule

module program_counter (
    // Sinais de controle
    input clk,
    input rst_n,
    input wire pc_src,
    input wire zero,
    // Valores da instrução
    input wire[63:0] immediate,
    output wire[63:0] pc
);

    wire[63:0] pc_next;
    wire[63:0] primary_adder_res, secondary_adder_res;
    wire clk_pc;

    assign pc_next = (pc_src & zero) ? secondary_adder_res : primary_adder_res;

    adder #(.SIZE(64)) primary_adder (
        .X(pc),
        .Y(64'd4),
        .Cin(1'b0),
        .S(primary_adder_res)
    );

    adder #(.SIZE(64)) secondary_adder (
        .X(pc),
        .Y(immediate),
        .Cin(1'b0),
        .S(secondary_adder_res)
    );

    pc_counter contador_pc (
        .clk_in(clk),
        .rst_n(rst_n),
        .clk_out(clk_pc)
    );

    register_with_reset PC (.IN(pc_next), .OUT(pc), .RST(rst_n), .LOAD(1'b1), .CLK(clk_pc));

endmodule

/* 
    Arquivo de registradores: parametrizado pelo tamanho das palavras e quantidade de registradores
    OBS: Para um banco de registradores com n registradores, haverá log2(n) bits nos seletores
*/
module regfile #(parameter SIZE = 64) (
    // Seletores dos registradores cujos valores estarão em Da e Db, respectivamente
    input [4:0] rs1, 
    input [4:0] rs2,
    // Os registradores só terão LOAD se este sinal estiver ativo
    input WE,
    // Entrada de dados e seletor do registor em que a palavra Din será salva
    input [SIZE-1:0] Din,
    input [4:0] rd,
    // Clock
    input CLK,
    // Saída de dados
    output [SIZE-1:0] D1,
    output [SIZE-1:0] D2
);
    genvar i; // Variável de controle para gerar os registradores

    wire[SIZE-1:0] r[31:0];
    wire[31:0] loaders;

    decoder5to32 LOAD_DECODER (
        .IN(rd),
        .OUT(loaders),
        .EN(WE)
    );

    assign r[0] = 64'b0; // x0
    generate
        for (i = 1; i < 32; i = i + 1) begin: registers
            register xN (.IN(Din), .LOAD(loaders[i]), .CLK(CLK), .OUT(r[i]));
        end
    endgenerate

    assign D1 = r[rs1];
    assign D2 = r[rs2];

endmodule

module register_with_reset #(parameter SIZE=64) (
  input wire[SIZE-1:0] IN,
  output reg[SIZE-1:0] OUT,
  input RST,
  input wire LOAD,
  input wire CLK
);

  always @(posedge CLK or negedge RST) begin
    if (~RST)
      OUT <= {SIZE{1'b0}};
    else if (LOAD)
      OUT <= IN;
  end

endmodule

module register #(parameter SIZE=64) (
  input wire[SIZE-1:0] IN,
  output reg[SIZE-1:0] OUT,
  input wire LOAD,
  input wire CLK
);

  always @(posedge CLK) begin
    if (LOAD)
      OUT <= IN;
  end

endmodule

module ula #(parameter SIZE = 64) (
  input[63:0] s1,
  input[63:0] s2,
  input[6:0] funct7,
  input[2:0] funct3,
  input[3:0] alu_cmd,
  output reg [63:0] res,
  output [3:0] alu_flags
);

  wire[63:0] sum;
  wire cout, sub;
  wire[63:0] out_and, out_or, out_xor;

  assign sub = (alu_cmd == 4'b0011) | (alu_cmd == 4'b0 & ~|funct3 & funct7[5]);

  // Flags
  assign overflow = cout;
  assign zero = ~| res;
  assign msb = res[SIZE-1];

  assign alu_flags = {1'b0, overflow, msb, zero};

  // Operações lógicas
  assign out_and = s1 & s2;
  assign out_or = s1 | s2;
  assign out_xor = s1 ^ s2;

  // Somador para calcular soma e diferença
  adder #(.SIZE(SIZE)) adder (
    .X(s1),
    .Y(s2 ^ {SIZE{sub}}),
    .S(sum),
    .Cin(sub),
    .Cout(cout)
  );
  
  // Seleção da saída
  always @(*) begin
    case (funct3)
      3'b000: res = sum;
      3'b100: res = out_xor;
      3'b110: res = out_or;
      3'b111: res = out_and;
      default: res = sum;
    endcase
  end

endmodule

module fd_grupo_1 
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