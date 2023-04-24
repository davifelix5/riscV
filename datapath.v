/**************************************************************************

Fluxo de dados LOAD-STORE
Grupo 1
    Davi Félix
    Rodrigo Sinato
    Natham Pez

Para rodar: 
    iverilog -o datapath datapath_testbench.v && vvp datapath

    O módulo datapath_testbench.v já inclui todos os módulos necessários 
(que estão também inclusos neste envio) e mostrará os resultados dos registradores
Ra e Rb no display. Além disso, é gerado um arquivo waveform que pode ser lido 
a partir do software gtkwave.
    Enviamos um arquivo .gtkw que contém o funcionamento do nosso fluxo de dados. 
Ele pode ser aberto pelo comando:
    gtkwave final.gtkw


**************************************************************************/

`include "./datamemory.v"
`include "./regfile.v"
`include "./somador.v"

module DATAPATH (
    input wire[4:0] Ra,
    input wire[4:0] Rb,
    input wire[4:0] C,
    input WE_RF,
    input WE_MEM,
    input[4:0] Rw,
    input wire CLK,
    output wire[63:0] DEBUG_Dout,
    output wire[63:0] DEBUG_Ra_out,
    output wire[63:0] DEBUG_Rb_out
);

    // Sinais de controle da UC
    wire[63:0] DM_in, DM_out, RF_out_b, RF_out_a;
    wire[4:0] DM_ADDR;
    // Valores para inspecionar as saídas
    assign DEBUG_Ra_out = RF_out_a;
    assign DEBUG_Dout = DM_out;
    assign DEBUG_Rb_out = RF_out_b;

    // Memória de dados
    DATAMEMORY MEM (
        // Endereço da memória para ler
        .ADDR(DM_ADDR), 
        // Write-Enable da memória
        .WE(WE_MEM), 
        // O valor do registrador Ra é salvo na memória na borda de subida do clock se WE é 1
        .D_in(RF_out_a),
        // Saída de dados da memória
        .D_out(DM_out), 
        .CLK(CLK)
    );

    REGFILE regfile (
        // Seletor do registrador cujo valor estará na saída Da
        .Ra(Ra),
        // Seletor do registrador cujo valor estará na saída Db
        .Rb(Rb),
        // Caso esteja desativo, os loads não funcionam
        .WE(WE_RF),
        // Entrada de dados a serem salvos no registrador
        .Din(DM_out),
        // Seletor do registrador em que a palavra Din será escrita
        .Rw(Rw),
        .CLK(CLK),
        // Saídas de dados
        .Da(RF_out_a),
        .Db(RF_out_b)
    );

    // Somador para somar o endereço de origem da memória com o offset fornecido
    SOMADOR #(.SIZE(5)) SOM ( 
        // Primeiro elemento da soma 
        .X(RF_out_b[4:0]), // Endereço base da memória é o registrador Rb
        // Segundo elemento da soma
        .Y(C), // Offset do endereço fornecido pela UC no sinal C
        // Carry-in e carry-out
        .Cin(1'b0),
        .Cout(Cout),
        // Resultado da soma
        .S(DM_ADDR) // O resultado da soma vai para o endereço final da memória
    );

endmodule