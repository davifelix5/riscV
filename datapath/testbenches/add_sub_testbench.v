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

`include "datapath/testbenches/add_sub.v"

module LOAD_STORE_testbench;

    reg[4:0] rs1, rs2, rd;
    reg[11:0] immediate;
    reg CLK, WE_RF, WE_MEM;
    reg sub, I_type, R_type;

    ADD_SUB UUT (
        .rs1(rs1),
        .rs2(rs2),
        .rd(rd),
        .sub(sub),
        .I_type(I_type),
        .R_type(R_type),
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
        I_type = 1;
        R_type = 0;
        sub = 0;
        immediate = 12'd16;  // Palavra 16 na memória
        WE_RF = 1'b1; // Habilita escrita nos registradores
        WE_MEM = 1'b0; // Desabilita escrita na memória
        #10;

        // st x1, 20(x0)
        rd = 1; // Escrita no registrador x1
        rs2 = 0; // Registrador x0
        rs1 = 1;
        I_type = 1;
        R_type = 0;
        sub = 0;
        immediate = 12'd20;  // Palavra 10 na memória
        WE_RF = 0; // Desabilita escrita nos registradores
        WE_MEM = 1; // Habilita escrita na memória
        #10

        // ld x5, 21(x0)
        rd = 5;
        rs2 = 0;
        rs1 = 1;
        I_type = 1;
        R_type = 0;
        sub = 0;
        immediate = 12'd21; 
        WE_RF = 1;
        WE_MEM = 0;
        #10

        // add x10, x1, x5
        rd = 10;
        rs1 = 1;
        rs2 = 5;
        I_type = 0;
        R_type = 1;
        sub = 0;
        immediate = 12'd20; 
        WE_RF = 1;
        WE_MEM = 0;
        #10

        // ld x11, 30(x0)
        rd = 11;
        rs1 = 1;
        rs2 = 0;
        I_type = 1;
        R_type = 0;
        sub = 0;
        immediate = 12'd30; 
        WE_RF = 1;
        WE_MEM = 0;
        #10

        // sub x20, x5, x11 
        rd = 20;
        rs1 = 5;
        rs2 = 11;
        I_type = 0;
        R_type = 1;
        sub = 1;
        immediate = 12'd30; 
        WE_RF = 1;
        WE_MEM = 0;
        #10

        // sub x21, x10, x11 
        rd = 21;
        rs1 = 10;
        rs2 = 11;
        I_type = 0;
        R_type = 1;
        sub = 1;
        immediate = 12'd30; 
        WE_RF = 1;
        WE_MEM = 0;
        #200;
        $finish;
    end

    always #5 CLK = ~CLK;


endmodule