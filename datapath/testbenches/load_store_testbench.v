/**************************************************************************

Fluxo de dados LOAD-STORE
Grupo 1
    Davi Félix
    Rodrigo Sinato
    Natham Pez

Para rodar: 
    iverilog -o datapath datapath_testbench.v && vvp datapath

    O módulo datapath_testbench.v já inclui todos os módulos necessários 
(que estão também inclusos neste envio) e mostrará os resutaldos dos registradores
Ra e Rb no display. Além disso, égerado um arquivo waveform que pode ser lido 
a partir do software gtkwave.
    Enviamos um arquivo .gtkw que contém o funcionamento do nosso fluxo de dados. 
Ele pode ser aberto pelo comando:
    gtkwave final.gtkw


**************************************************************************/

`include "datapath/testbenches/load_store.v"

module LOAD_STORE_testbench;

    reg[4:0] Ra, Rb, Rw, C;
    reg CLK, WE_RF, WE_MEM;
    wire[63:0] Dout, Ra_out;

    LOAD_STORE UUT (
        .Ra(Ra),
        .Rb(Rb),
        .C(C), 
        .WE_RF(WE_RF),
        .WE_MEM(WE_MEM),
        .Rw(Rw),
        .CLK(CLK),
        .DEBUG_Dout(Dout),
        .DEBUG_Ra_out(Ra_out)
    );

    initial begin
        $dumpfile("datapath/testbenches/vvp/waveforms2.vcd");
        $dumpvars(0,LOAD_STORE_testbench);
        $monitor("Dout = %d; RA_out = %d; CLK = %b", Dout, Ra_out, CLK);
        CLK = 0;
        
        // ld x1, 16(x0)
        Rw = 1'b1; // Escrita no registrador x1
        Rb = 1'b0; // Registrador x0
        Ra = 0;
        C = 5'd16;  // Palavra 16 na memória
        WE_RF = 1'b1; // Habilita escrita nos registradores
        WE_MEM = 1'b0; // Desabilita escrita na memória
        
        #20;

        // st x1, 20(x0)
        WE_MEM = 1'b1; // Habilita escrita na memória
        WE_RF = 1'b0; // Desabilita escrita no registrador
        Ra = 1; // Seleciona o registrador x1
        C = 5'd20; // Palavra 20 na memória

        #200;
        $finish;
    end

    always #5 CLK = ~CLK;


endmodule