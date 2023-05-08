module program_counter (
    input CLK,
    input LOAD,
    input RST,
    output wire [63:0] addr
);

    wire [63:0] next;

    adder #(.SIZE(64)) adder (
        .X(addr),
        .Y(64'b1),
        .Cin(1'b0),
        .S(next)
    );

    register_with_reset PC (.IN(next), .OUT(addr), .RST(RST), .LOAD(LOAD), .CLK(CLK));

endmodule