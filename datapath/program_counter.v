module program_counter (
    input CLK,
    input LOAD,
    input RST,
    input wire pc_next_sel,
    input wire[63:0] immediate,
    output wire [63:0] addr,
    input wire[6:0] opcode,
    input wire[2:0] func,
    input wire EQ,
    input wire LT_SN,
    input wire LT_UN,
    input wire GT_SN,
    input wire GT_UN
);

    reg sel;

    always @(*) begin
        case (func)
            3'b000: sel = EQ;
            3'b001: sel = ~EQ;
            3'b100: sel = LT_SN;
            3'b101: sel = GT_SN;
            3'b110: sel = LT_UN;
            3'b111: sel = GT_UN;
            default: sel = 0;
        endcase
    end

    assign final_sel = opcode == 7'b1100011 ? sel : 0;

    wire[63:0] next;
    wire[63:0] pc_next;

    assign pc_next = final_sel ? immediate : 64'd4;

    adder #(.SIZE(64)) adder (
        .X(addr),
        .Y(pc_next),
        .Cin(1'b0),
        .S(next)
    );

    register_negedge_with_reset PC (.IN(next), .OUT(addr), .RST(RST), .LOAD(LOAD), .CLK(CLK));

endmodule