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

`include "datapath/datapath.v"

module LOAD_STORE_testbench;

    reg[4:0] rs1, rs2, rd;
    reg[11:0] immediate;
    reg CLK, WE_RF, WE_MEM;
    reg sub, ULA_din2_sel, RF_din_sel;

    datapath UUT (
        .rs1(rs1),
        .rs2(rs2),
        .rd(rd),
        .sub(sub),
        .ULA_din2_sel(ULA_din2_sel),
        .RF_din_sel(RF_din_sel),
        .immediate(immediate), 
        .WE_RF(WE_RF),
        .WE_MEM(WE_MEM),
        .CLK(CLK)
    );

    initial begin
        $dumpfile("datapath/testbenches/vvp/waveforms3.vcd");
        $dumpvars(0,LOAD_STORE_testbench);
        CLK = 0;
        
        // ld x1, 16(x0)
        rd = 1; // Escrita no registrador x1
        rs2 = 0; // Registrador x0
        rs1 = 0;
        ULA_din2_sel = 1;
        RF_din_sel = 0;
        sub = 0;
        immediate = 12'd16;  // Palavra 16 na memória
        WE_RF = 1; // Habilita escrita nos registradores
        WE_MEM = 0; // Desabilita escrita na memória
        #10;

        // ld x5, 21(x0)
        rd = 5;
        rs2 = 0;
        rs1 = 0;
        ULA_din2_sel = 1;
        RF_din_sel = 0;
        sub = 0;
        immediate = 12'd21; 
        WE_RF = 1;
        WE_MEM = 0;
        #10

        // add x10, x1, x5
        rd = 10;
        rs1 = 1;
        rs2 = 5;
        ULA_din2_sel = 0;
        RF_din_sel = 1;
        sub = 0;
        immediate = 12'bx; 
        WE_RF = 1;
        WE_MEM = 0;
        #10

        // sub x20, x5, x1
        rd = 20;
        rs1 = 5;
        rs2 = 1;
        ULA_din2_sel = 0;
        RF_din_sel = 1;
        sub = 1;
        immediate = 12'dx; 
        WE_RF = 1;
        WE_MEM = 0;
        #10

        // st x10, 10(x0)
        rd = 0;
        rs1 = 0;
        rs2 = 10;
        ULA_din2_sel = 1;
        RF_din_sel = 0;
        sub = 0;
        immediate = 12'd10;
        WE_RF = 0;
        WE_MEM = 1;
        #10

        // st x20, 11(x0)
        rd = 0;
        rs1 = 0;
        rs2 = 20;
        ULA_din2_sel = 1;
        RF_din_sel = 0;
        sub = 0;
        immediate = 12'd11;
        WE_RF = 0;
        WE_MEM = 1;
        #10

        // addi x20, x20, 45
        rd = 20;
        rs1 = 20;
        rs2 = 5'bx;
        ULA_din2_sel = 1;
        RF_din_sel = 1;
        sub = 0;
        immediate = 12'd45;
        WE_RF = 1;
        WE_MEM = 0;
        #10

        // ld x21, 30(x0)
        rd = 21; // Escrita no registrador x1
        rs2 = 0; // Registrador x0
        rs1 = 0;
        ULA_din2_sel = 1;
        RF_din_sel = 0;
        sub = 0;
        immediate = 12'd30;  // Palavra 16 na memória
        WE_RF = 1; // Habilita escrita nos registradores
        WE_MEM = 0; // Desabilita escrita na memória
        #10;

        // addi x30, x21, -401
        rd = 30;
        rs1 = 21;
        rs2 = 5'bx;
        ULA_din2_sel = 1;
        RF_din_sel = 1;
        sub = 0;
        immediate = 12'b111111001110;
        WE_RF = 1;
        WE_MEM = 0;
        #10
        
        $finish;
    end

    always #5 CLK = ~CLK;


endmodule