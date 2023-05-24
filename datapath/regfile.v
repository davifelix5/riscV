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
        for (i = 1; i < 32; i = i + 1) begin
            register xN (.IN(Din), .LOAD(loaders[i]), .CLK(CLK), .OUT(r[i]));
        end
    endgenerate

    assign D1 = r[rs1];
    assign D2 = r[rs2];

endmodule