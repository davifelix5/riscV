module full #(
  parameter i_addr_bits = 6,
  parameter d_addr_bits = 6
) (
  input wire clk,
  input wire rst_n
);

  wire [i_addr_bits-1:0] i_mem_addr;
  wire [31:0] i_mem_data;
  wire d_mem_we;
  wire [d_addr_bits-1:0] d_mem_addr;
  wire [63:0] d_mem_data;


  polirv #(.i_addr_bits(6), .d_addr_bits(6)) RISCV (
    .clk(clk),
    .rst_n(rst_n),
    .i_mem_addr(i_mem_addr),
    .i_mem_data(i_mem_data),
    .d_mem_we(d_mem_we),
    .d_mem_addr(d_mem_addr),
    .d_mem_data(d_mem_data)
  );

  datamemory #(.SIZE(64), .addr_width(d_addr_bits)) DM (
    .d_mem_addr(d_mem_addr),
    .d_mem_we(d_mem_we),
    .d_mem_data(d_mem_data),
    .clk(clk)
  );

  instruction_memory #(.i_addr_bits(i_addr_bits)) IM (
    .i_mem_addr(i_mem_addr),
    .i_mem_data(i_mem_data)
  );
  
endmodule