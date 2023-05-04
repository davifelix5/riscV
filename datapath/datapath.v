/**************************************************************************

Fluxo de dados ADD-SUB
Grupo 1
    Davi Félix
    Rodrigo Sinato
    Natham Pez

**************************************************************************/

`include "datapath/datamemory.v"
`include "datapath/regfile.v"
`include "datapath/ula.v"

module datapath (
    input wire[4:0] rs1,
    input wire[4:0] rs2,
    input wire[4:0] rd,
    input wire[11:0] immediate,
    input wire sub, // entra nas functs
    input WE_RF,
    input WE_MEM,
    input wire RF_din_sel, // indica se a instrução é do tipo R
    input wire ULA_din2_sel, // indica se a instrução é do tipo I
    input wire CLK
);
    // Fios do datapath
    wire[63:0] DM_in, DM_out, Dout_rs1, Dout_rs2;
    wire[4:0] DM_ADDR;
    wire[63:0] ula, RF_Din, ULA_Din2;
    
    // Mutiplexadores para add-sub
    assign RF_Din = RF_din_sel ? ula : DM_out;
    assign ULA_Din2 = ULA_din2_sel ? {{52{immediate[11]}}, immediate} : Dout_rs2;

    // Memória de dados
    DATAMEMORY MEM (
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

    REGFILE regfile (
        // Seletor do registrador cujo valor estará na saída Da
        .Ra(rs1),
        // Seletor do registrador cujo valor estará na saída Db
        .Rb(rs2),
        // Caso esteja desativo, os loads não funcionam
        .WE(WE_RF),
        // Entrada de dados a serem salvos no registrador
        .Din(RF_Din),
        // Seletor do registrador em que a palavra Din será escrita
        .Rw(rd),
        .CLK(CLK),
        // Saídas de dados
        .Da(Dout_rs1),
        .Db(Dout_rs2)
    );

    // Somador para somar o endereço de origem da memória com o offset fornecido
    ula ULA ( 
        .s1(Dout_rs1),
        .s2(ULA_Din2),
        .sub(sub),
        .res(ula)
    );

endmodule