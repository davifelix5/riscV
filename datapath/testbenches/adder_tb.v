module adder_tb;

    reg[31:0] A, B;
    wire[31:0] Res;
    reg Cin;
    wire Cout;

    adder #(.SIZE(32)) UUT(
        .X(A),
        .Y(B),
        .S(Res),
        .Cin(Cin),
        .Cout(Cout)
    );

    initial begin
        $monitor("A: %d; B: %d; S = %d", A, B, Res);
        Cin = 0;
        A = 32'b111110100; // 500
        B = 32'b11111111111111111111111000111110; // -450
        #5000;
        A = 32'b111110100; // 500
        B = 32'b000111000010; // 450
        #5000;
        A = 32'b001110110110; // 950
        B = 32'b11111111111111111111110000011000; // -1000
        
    end

endmodule