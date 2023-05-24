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

module datapath_tb;

    reg[4:0] rs1, rs2, rd;
    reg[11:0] immediate;
    reg CLK, WE_RF, WE_MEM;
    reg sub, ULA_din2_sel;
    reg[1:0] RF_din_sel;
    reg reset_pc, pc_next_sel, pc_adder_sel;

    datapath UUT (
        .sub(sub),
        .ULA_din2_sel(ULA_din2_sel),
        .RF_din_sel(RF_din_sel),
        .WE_RF(WE_RF),
        .WE_MEM(WE_MEM),
        .CLK(CLK),
        .load_pc(1'b1),
        .reset_pc(reset_pc),
        .pc_next_sel(pc_next_sel),
        .pc_adder_sel(pc_adder_sel)
    );

    initial begin
        $dumpfile("datapath/testbenches/waves/datapath_with_im/waveforms3.vcd");
        $dumpvars(0, datapath_tb);
        CLK = 0;
        pc_next_sel = 1'b0;
        pc_adder_sel = 1'b0;

        reset_pc = 0;
        #10
        reset_pc = 1;

        // ld
        ULA_din2_sel = 1;
        RF_din_sel = 2'd0;
        sub = 0;
        WE_RF = 1; // Habilita escrita nos registradores
        WE_MEM = 0; // Desabilita escrita na memória
        #10;

        // ld
        ULA_din2_sel = 1;
        RF_din_sel = 2'd0;
        sub = 0;
        WE_RF = 1;
        WE_MEM = 0;
        #10

        // add
        ULA_din2_sel = 0;
        RF_din_sel = 2'd1;
        sub = 0;
        WE_RF = 1;
        WE_MEM = 0;
        #10

        // sub
        ULA_din2_sel = 0;
        RF_din_sel = 2'd1;
        sub = 1;
        WE_RF = 1;
        WE_MEM = 0;
        #10

        // st
        ULA_din2_sel = 1;
        RF_din_sel = 2'd0;
        sub = 0;
        WE_RF = 0;
        WE_MEM = 1;
        #10

        // addi
        ULA_din2_sel = 1;
        RF_din_sel = 2'd1;
        sub = 0;
        WE_RF = 1;
        WE_MEM = 0;
        #10

        // ld
        ULA_din2_sel = 1;
        RF_din_sel = 2'd0;
        sub = 0;
        WE_RF = 1; // Habilita escrita nos registradores
        WE_MEM = 0; // Desabilita escrita na memória
        #5;

        /*
        // branch
        sub = 1;
        ULA_din2_sel = 0;
        */

        // auipc
        RF_din_sel = 2'd3;
        pc_adder_sel = 1'b1;
        pc_next_sel = 1'b0;
        WE_RF = 1;
        sub = 0;
        WE_MEM = 0;
        #10

        // jal
        RF_din_sel = 2'd2;
        pc_adder_sel = 1'b1;
        pc_next_sel = 1'b1;
        WE_RF = 1;
        sub = 0;
        WE_MEM = 0;
        #10

        // jalr
        RF_din_sel = 2'd2;
        pc_adder_sel = 1'b0;
        pc_next_sel = 1'b1;
        WE_RF = 1;
        WE_MEM = 0;
        sub = 0;
        #10;

        // add
        ULA_din2_sel = 0;
        RF_din_sel = 2'd1;
        pc_next_sel = 1'b0;
        pc_adder_sel = 1'b0;
        sub = 0;
        WE_RF = 1;
        WE_MEM = 0;
        #10

        $finish;
    end

    always #5 CLK = ~CLK;


endmodule