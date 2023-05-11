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


module adder #(parameter SIZE=32) (
    input wire[SIZE-1:0] X,
    input wire[SIZE-1:0] Y,
    input wire Cin,
    output wire[SIZE-1:0] S,
    output wire Cout
);
    wire[SIZE:0] cins;
    genvar i;

    assign cins[0] = Cin;

    generate
      for (i=0; i < SIZE; i = i + 1)
        adder1bit SOMA (.X(X[i]), .Y(Y[i]), .S(S[i]), .Cin(cins[i]), .Cout(cins[i+1]));
    endgenerate

    assign Cout = cins[SIZE];

    

endmodule