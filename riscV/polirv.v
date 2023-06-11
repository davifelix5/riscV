module polirv 
#(
    parameter i_addr_bits = 6,
    parameter d_addr_bits = 6
) (
    input clk, rst_n,                       // clock borda subida, reset assíncrono ativo baixo
    output [i_addr_bits-1:0] i_mem_addr,
    input  [31:0]            i_mem_data,
    output                   d_mem_we,
    output [d_addr_bits-1:0] d_mem_addr,
    inout  [63:0]            d_mem_data
);

    wire [6:0] opcode;
    wire rf_we, d_mem_we;
    wire rf_src, alu_src, pc_src;
    wire [3:0] alu_flags, alu_cmd;

    uc UC (
        .rst_n(rst_n),
        .clk(clk),
        .opcode(opcode),
        .rf_we(rf_we),
        .d_mem_we(d_mem_we),
        .alu_flags(alu_flags),
        .alu_cmd(alu_cmd),
        .rf_src(rf_src),
        .alu_src(alu_src),
        .pc_src(pc_src)
    );

    fd FD (
        .clk(clk),
        .rst_n(rst_n),
        .rf_we(rf_we),
        .d_mem_we(d_mem_we),
        .rf_src(rf_src),
        .alu_src(alu_src),
        .pc_src(pc_src),
        .alu_flags(alu_flags),
        .alu_cmd(alu_cmd),
        .d_mem_data(d_mem_data),
        .d_mem_addr(d_mem_addr),
        .i_mem_addr(i_mem_addr),
        .i_mem_data(i_mem_data),
        .opcode(opcode)  
    );



endmodule