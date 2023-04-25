
// Memória de dados
module DATAMEMORY (
    input wire[4:0] ADDR, // Endereço de memória
    input wire WE, // Write-Enable: caso esteja ativo, valor em D_in é salvo no endereço ADDR
    input wire[63:0] D_in, // Entrada de dados
    output wire[63:0] D_out, // Saída de dados
    input wire CLK
);


    reg[63:0] MEM[31:0];
    
    // Inicializando a palavra 16 com um valor arbitrário para teste
    initial begin
        MEM[16] = 64'd731; 
    end

    always @(posedge CLK) begin
        if (WE)
            MEM[ADDR] <= D_in;
    end

    assign D_out = MEM[ADDR];

endmodule