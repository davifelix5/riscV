module instruction_memory(
    input wire[63:0] ADDR,
    output wire[31:0] OUTPUT
);

    reg[31:0] memory[500:0]; // 2^32 valores na memória

    /* initial begin
        memory[0] = {12'd16, 5'd0, 3'b010, 5'd1, 7'b000011}; // ld x1, 16(x0)
        memory[1] = {12'd21, 5'd0, 3'b010, 5'd2, 7'b000011}; //ld x2 21(x0)
        memory[2] = {7'b0, 5'd2, 5'd1, 3'b000, 5'd3, 7'b0110011}; // add x3, x1, x2
        memory[3] = {7'b0100000, 5'd1, 5'd2, 3'b000, 5'd4, 7'b0110011}; // sub x4, x1, x2
        memory[4] = {7'b0, 5'd4, 5'd0, 3'b010, 5'b10010, 7'b0100011}; // st x4, 18(x0)
        memory[5] = {12'd50, 5'd4, 3'b000, 5'd5, 7'b0010011}; // addi x5, x4, 50
        memory[6] = {12'd18, 5'd0, 3'b010, 5'd6, 7'b000011}; // ld x6, 18(x0)
        // memory[7] = 32'b11111110000100010001110011100011; // bne x2, x1, -8
        // memory[7] = 32'b11111110000000000000011011100011; // beq x1, x2, -20
        memory[7] = 32'b00000000000000000001101000010111; // auipc x20, 4096 
        memory[8] = 32'b00111010000000000000000011101111; // jal x1, 928 (928 = 4*232)
        memory[240] = 32'b00000000100000000000000001100111; // jalr x0, 2(0)

    end */

    initial begin
        memory[0] = 32'b00000000101000000000000010010011; // addi x1, x0, 10
        memory[1] = 32'b00000000111100000000000100010011; // addi x2, x0, 15
        memory[2] = 32'b00000000001000001000000110110011; // addi x3, x1, x2
        memory[3] = 32'b01000000001000001000001000110011; // sub x4, x1, x2
    end

    assign OUTPUT = memory[ADDR];

endmodule