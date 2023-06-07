module program_counter (
    // Sinais de controle
    input CLK,
    input RST,
    input wire pc_src,
    // Valores da instrução
    input wire[63:0] immediate,
    output wire[63:0] pc
);

    reg sel;

    wire[63:0] pc_next;
    wire[63:0] primary_adder_res, secondary_adder_res;

    assign pc_next = pc_src ? secondary_adder_res : primary_adder_res;

    adder #(.SIZE(64)) primary_adder (
        .X(pc),
        .Y(64'd4),
        .Cin(1'b0),
        .S(primary_adder_res)
    );

    adder #(.SIZE(64)) secondary_adder (
        .X(pc),
        .Y(immediate),
        .Cin(1'b0),
        .S(secondary_adder_res)
    );

    register_with_reset PC (.IN(pc_next), .OUT(pc), .RST(RST), .LOAD(1'b1), .CLK(CLK));

endmodule