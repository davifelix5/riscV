module instruction_memory(
    input wire[63:0] ADDR,
    output wire[31:0] OUTPUT
);

    reg[31:0] memory[31:0]; // 2^64 valores na memória

    initial begin
        memory[0] = {12'd16, 5'd0, 3'b010, 5'd1, 7'b000011}; // ld x1, 16(x0)
        memory[1] = {12'd21, 5'd0, 3'b010, 5'd2, 7'b000011}; //ld x2 21(x0)
        memory[2] = {7'b0, 5'd2, 5'd1, 3'b000, 5'd3, 7'b0110011}; // add x3, x1, x2
        memory[3] = {7'b0100000, 5'd1, 5'd2, 3'b000, 5'd4, 7'b0110011}; // sub x4, x1, x2
        memory[4] = {7'b0, 5'd4, 5'd0, 3'b010, 5'b10010, 7'b0100011}; // st x4, 18(x0)
        memory[5] = {12'd50, 5'd4, 3'b000, 5'd5, 7'b0010011}; // addi x5, x4, 50
        memory[6] = {12'd18, 5'd0, 3'b010, 5'd6, 7'b000011}; // ld x6, 30(x0)
        memory[7] = {1'b1, 6'b111111, 5'd1, 5'd2, 3'b001, 5'b11001, 7'b1100011}; // bneq x1, x2, -4
    end

    assign OUTPUT = memory[ADDR];

endmodule