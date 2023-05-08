`include "datapath/instruction_memory.v"

module instruction_memory_testbench;

    reg[63:0] addr_tb;
    wire[31:0] output_tb;

    instruction_memory UUT (
        .ADDR(addr_tb),
        .OUTPUT(output_tb)
    );

    initial begin        
        $monitor("%d %b", addr_tb, output_tb);
        addr_tb = 0;
        #10;
        addr_tb = 1;
        #10;
        addr_tb = 2;
        #10;
        addr_tb = 3;
        #10;
        addr_tb = 4;
        #10;
        addr_tb = 5;
        #1000;
        $finish;
    end

endmodule