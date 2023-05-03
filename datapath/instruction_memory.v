module instruction_memory(
    input wire[63:0] ADDR,
    output wire[31:0] OUTPUT
);

    reg[31:0] memory[31:0]; // 2^64 valores na memória

    initial begin
        memory[0] = {12'd16, 5'd0, 3'b010, 5'd1, 7'b000011};
        memory[1] = {12'd21, 5'd0, 3'b010, 5'd2, 7'b000011};
        memory[2] = {7'b0, 5'd2, 5'd1, 3'b000, 5'd3, 7'b0110011};
        memory[3] = {7'b0100000, 5'd2, 5'd1, 3'b000, 5'd4, 7'b0110011};
        memory[4] = {7'b0, 5'd4, 5'b0, 3'b010, 5'b11110, 7'b0100011};
        memory[5] = {12'd50, 5'd4, 3'b000, 5'd5, 7'b0010011};
    end

    assign OUTPUT = memory[ADDR];

endmodule