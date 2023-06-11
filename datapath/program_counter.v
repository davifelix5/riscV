module program_counter (
    // Sinais de controle
    input clk,
    input rst_n,
    input wire pc_src,
    input wire zero,
    // Valores da instrução
    input wire[63:0] immediate,
    output wire[63:0] pc
);

    wire[63:0] pc_next;
    wire[63:0] primary_adder_res, secondary_adder_res;
    wire clk_pc;

    assign pc_next = (pc_src & zero) ? secondary_adder_res : primary_adder_res;

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

    pc_counter contador_pc (
        .clk_in(clk),
        .rst_n(rst_n),
        .clk_out(clk_pc)
    );

    register_with_reset PC (.IN(pc_next), .OUT(pc), .RST(rst_n), .LOAD(1'b1), .CLK(clk_pc));

endmodule