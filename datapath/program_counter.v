module program_counter (
    // Sinais de controle
    input CLK,
    input LOAD,
    input RST,
    input wire pc_next_sel,
    input wire pc_adder_sel,
    input wire branch,
    // Valores da instrução
    input wire[63:0] immediate,
    input wire[2:0] func,
    // Saída do regfile
    input wire[63:0] Dout_rs1,
    // Flags
    input wire EQ,
    input wire LT_SN,
    input wire LT_UN,
    input wire GT_SN,
    input wire GT_UN,
    // Endereço da memória de instruções
    output wire[63:0] primary_adder_res,
    output wire[63:0] secondary_adder_res,
    output wire[63:0] pc
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

    wire[63:0] pc_adder, pc_next;
    wire final_pc_adder_sel, final_pc_next_sel;

    assign final_pc_next_sel = branch ? sel : pc_next_sel;
    assign final_pc_adder_sel = branch | pc_adder_sel; 

    assign pc_adder = final_pc_adder_sel ? pc : Dout_rs1;
    assign pc_next = final_pc_next_sel ? secondary_adder_res : primary_adder_res;
    

    adder #(.SIZE(64)) primary_adder (
        .X(pc),
        .Y(64'd4),
        .Cin(1'b0),
        .S(primary_adder_res)
    );

    adder #(.SIZE(64)) secondary_adder (
        .X(immediate),
        .Y(pc_adder),
        .Cin(1'b0),
        .S(secondary_adder_res)
    );

    register_with_reset PC (.IN(pc_next), .OUT(pc), .RST(RST), .LOAD(LOAD), .CLK(CLK));

endmodule