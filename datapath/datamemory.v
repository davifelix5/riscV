
// Memória de dados
module datamemory #(parameter SIZE = 64, parameter N = 32) (
    input wire[$clog2(N) - 1:0] ADDR, // Endereço de memória
    input wire WE, // Write-Enable: caso esteja ativo, valor em D_in é salvo no endereço ADDR
    input wire[SIZE-1:0] D_in, // Entrada de dados
    output wire[SIZE-1:0] D_out, // Saída de dados
    input wire CLK
);


    reg[SIZE-1:0] MEM[N - 1:0];
    
    // Inicializando a palavra 16 com um valor arbitrário para teste
    initial begin
        MEM[16] = 64'd730; 
        MEM[21] = 64'd312; 
        MEM[30] = 64'd1000;
    end

    always @(posedge CLK) begin
        if (WE)
            MEM[ADDR] <= D_in;
    end

    assign D_out = MEM[ADDR];

endmodule