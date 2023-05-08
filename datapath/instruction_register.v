module instruction_register (
    input wire clk,
    input wire[31:0] in,
    output wire[31:0] out
);
    register #(.SIZE(32)) IR (
        .CLK(clk),
        .IN(in),
        .OUT(out),
        .LOAD(1'b1)
    );
endmodule