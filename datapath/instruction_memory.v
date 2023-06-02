module instruction_memory(
    input wire[63:0] ADDR,
    output wire[31:0] OUTPUT
);

    reg[31:0] memory[500:0];

    initial begin
        memory[0] = 32'b00000000111100000000000100010011; // addi x2, x0, 15
        memory[1] = 32'b00000000101000000000000010010011; // addi x1, x0, 10
        memory[2] = 32'b00000000001000001000000110110011; // add x3, x1, x2
        memory[3] = 32'b01000000001000001000001000110011; // sub x4, x1, x2
        memory[4] = 32'b10000000000000000000001010010011; // addi x5, x0, 2048
        memory[5] = 32'b00000000010100101000001010110011; // add x5, x5, x5
        memory[6] = 32'b00000000010100101000001010110011; // add x5, x5, x5
        memory[7] = 32'b00000001000000101011001100000011; // ld x6, 16(x5)
        memory[8] = 32'b00000000000100101011101000100011; // st x1, 20(x5)
        memory[9] = 32'b00000001010000101011001110000011; // ld x7, 20(x5)
        memory[10] = 32'b00000001000000000000010001101111; // jal x8, 16
        memory[11] = 32'b11111100000101001101101011100011; // bge x9,x1,-44
        memory[14] = 32'b00000100101100000000010010010011; // addi x9, 75
        memory[15] = 32'b00000000000000000001010100010111; // auipc x10, 4096
        memory[16] = 32'b00000000000001000000000001100111; // jalr x0 0(x8)
    end

    assign OUTPUT = memory[ADDR];

endmodule