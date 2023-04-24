`include "./datamemory.v"

module DATAMEMORY_testbench;

    reg[4:0] ADDR;
    reg WE, CLK;
    reg[63:0] D_in;
    wire[63:0] D_out;

    DATAMEMORY UUT (
        .ADDR(ADDR),
        .WE(WE),
        .D_in(D_in),
        .D_out(D_out),
        .CLK(CLK)
    );

    initial begin
        $monitor("D_out = %d", D_out);
        CLK = 0;
        // Primeiro ciclo: setar o endereço ADD com 150
        WE = 1;
        D_in = 64'd150;
        ADDR = 5'b01011;
        #100
        WE = 0;
        D_in = 64'd300;
        ADDR = 5'b01011;
        #100
        $finish;
    end

    always #5 CLK = ~CLK;

endmodule