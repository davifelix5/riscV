
// Memória de dados
module datamemory #(parameter SIZE = 64, parameter addr_width = 6) (
    input wire[addr_width - 1:0] d_mem_addr, // Endereço de memória
    input wire d_mem_we, // Write-Enable: caso esteja ativo, valor em d_mem_data é salvo no endereço d_mem_addr
    inout[SIZE-1:0] d_mem_data, // Entrada e saída de dados
    input wire clk
);

    reg[SIZE-1:0] MEM[$pow(2, addr_width) - 1:0];
    
    // Inicializando com valores arbitrários para teste
    initial begin
        MEM[16] = 64'd731; 
        MEM[21] = 64'd312; 
        MEM[30] = 64'd1000;
    end

    always @(posedge clk) begin
        if (d_mem_we)
            MEM[d_mem_addr] <= d_mem_data;
    end

    assign d_mem_data = d_mem_we ? 64'bz : MEM[d_mem_addr];

endmodule