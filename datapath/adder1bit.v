module adder1bit (
    input wire X,
    input wire Y,
    input wire Cin,
    output wire S,
    output wire Cout
);

    assign xor1 = X ^ Y;
    assign S = xor1 ^ Cin;
    assign Cout = (X & Y) | (Cin & xor1);

endmodule