`include "datapath/reg.v"
/* 
    Arquivo de registradores: parametrizado pelo tamanho das palavras e quantidade de registradores
    OBS: Para um banco de registradores com n registradores, haverá log2(n) bits nos seletores
*/
module REGFILE #(parameter N = 32, parameter SIZE = 64) (
    // Seletores dos registradores cujos valores estarão em Da e Db, respectivamente
    input [$clog2(N) - 1:0] Ra, 
    input [$clog2(N) - 1:0] Rb,
    // Os registradores só terão LOAD se este sinal estiver ativo
    input WE,
    // Entrada de dados e seletor do registor em que a palavra Din será salva
    input [SIZE-1:0] Din,
    input [$clog2(N) - 1:0] Rw,
    // Clock
    input CLK,
    // Saída de dados
    output [SIZE-1:0] Da,
    output [SIZE-1:0] Db
);
    genvar i; // Variável de controle para gerar os registradores

    wire[SIZE-1:0] r[N-1:0];

    assign r[0] = 64'b0; // x0
    generate
        for (i = 1; i < N; i = i + 1) begin
            wire load_reg;
            assign load_reg = (Rw == i) ? 1 : 0;
            REG xN (.IN(Din), .LOAD(WE & load_reg), .CLK(CLK), .OUT(r[i]));
        end
    endgenerate

    assign Da = r[Ra];
    assign Db = r[Rb];

endmodule