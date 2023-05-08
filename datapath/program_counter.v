module program_counter (
    input CLK,
    input LOAD,
    input RST,
    output wire [63:0] addr
);

    wire [63:0] fio;

    register_with_reset PC (.IN(fio + 1), .OUT(fio), .RST(RST), .LOAD(LOAD), .CLK(CLK));

    assign addr = fio;

endmodule