`include "datapath/register.v"
`include "datapath/decoder5to32.v"
/* 
    Arquivo de registradores: parametrizado pelo tamanho das palavras e quantidade de registradores
    OBS: Para um banco de registradores com n registradores, haverá log2(n) bits nos seletores
*/
module regfile #(parameter SIZE = 64) (
    // Seletores dos registradores cujos valores estarão em Da e Db, respectivamente
    input [4:0] Ra, 
    input [4:0] Rb,
    // Os registradores só terão LOAD se este sinal estiver ativo
    input WE,
    // Entrada de dados e seletor do registor em que a palavra Din será salva
    input [SIZE-1:0] Din,
    input [4:0] Rw,
    // Clock
    input CLK,
    // Saída de dados
    output [SIZE-1:0] Da,
    output [SIZE-1:0] Db
);
    genvar i; // Variável de controle para gerar os registradores

    wire[SIZE-1:0] r[31:0];
    wire[31:0] loaders;

    decoder5to32 LOAD_DECODER (
        .IN(Rw),
        .OUT(loaders),
        .EN(WE)
    );

    assign r[0] = 64'b0; // x0
    generate
        for (i = 1; i < 32; i = i + 1) begin
            register xN (.IN(Din), .LOAD(loaders[i]), .CLK(CLK), .OUT(r[i]));
        end
    endgenerate

    assign Da = r[Ra];
    assign Db = r[Rb];

endmodule