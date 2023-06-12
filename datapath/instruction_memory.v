module instruction_memory #(
    parameter i_addr_bits = 6
) (
    input wire[i_addr_bits - 1:0] i_mem_addr,
    output wire[31:0] i_mem_data
);

    reg[31:0] memory[500:0];

    initial begin
        $readmemb("testes/mdc.bin", memory);
    end

    assign i_mem_data = memory[i_mem_addr];

endmodule