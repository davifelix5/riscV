module program_counter (
    input CLK,
    input LOAD,
    input RST,
    input wire pc_next_sel,
    input wire[11:0] immediate,
    output wire [63:0] addr
);

    wire[63:0] next;
    wire[63:0] pc_next;

    assign pc_next = pc_next_sel ? immediate : 64'b1;

    adder #(.SIZE(64)) adder (
        .X(addr),
        .Y(pc_next),
        .Cin(1'b0),
        .S(next)
    );

    register_negedge_with_reset PC (.IN(next), .OUT(addr), .RST(RST), .LOAD(LOAD), .CLK(CLK));

endmodule