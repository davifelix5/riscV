module instruction_memory(
    input wire[63:0] ADDR,
    output wire[31:0] OUTPUT
);

    reg[31:0] memory[500:0];

    initial begin
        $readmemb("testes/teste.bin", memory);
    end

    assign OUTPUT = memory[ADDR];

endmodule