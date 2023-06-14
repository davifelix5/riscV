
    // AluCmd     AluFlags
    // 0000: R    0: zero
    // 0001: I    1: MSB 
    // 0010: S    2: overflow
    // 0011: SB
    // 0100: U
    // 0101: UJ

module fd_padronizado
    #(  // Tamanho em bits dos barramentos
        parameter i_addr_bits = 6,
        parameter d_addr_bits = 6
    )(
    input clk, rst_n,                   // clock borda subida, reset assíncrono ativo baixo
    output [6:0] opcode,                    
    input  d_mem_we, rf_we,              // Habilita escrita na memória de dados e no banco de registradores
    input  [3:0] alu_cmd,                // ver abaixo
    output [3:0] alu_flags,
    input  alu_src,                      // 0: rf, 1: imm
            pc_src,                       // 0: +4, 1: +imm
            rf_src,                       // 0: alu, 1:d_mem
    output [i_addr_bits-1:0] i_mem_addr,
    input  [31:0]            i_mem_data,
    output [d_addr_bits-1:0] d_mem_addr,
    inout  [63:0]            d_mem_data
);

    wire[63:0] doA, doB, extended_instruction, r_multi1, r_multi2 , ULA_out, r_multi4, extended4;
    wire[4:0] rs1, rs2, rw, mux4B, regP_out, imm_gem;
    wire[63:0] pc_out, add4_out, add_sum_out, r_multi3;
  

    assign rs2 = i_mem_data[24:20];
    assign rs1 = i_mem_data[19:15];
    assign rw = i_mem_data[11:7];
    assign opcode = i_mem_data[6:0];
    assign i_mem_addr = r_multi3[7:2];
    assign d_mem_addr = ULA_out;

    PC pc1(.reset(rst_n),.en(1'b1),.clk_pc(clk),.data_in_pc(r_multi3), .data_out_pc(pc_out));

    Multiplex mux1(.a(doB), .b(extended_instruction), .s(alu_src), .result(r_multi1));
    Multiplex mux2(.a(ULA_out), .b(d_mem_data), .s(rf_src), .result(r_multi2));
    Multiplex mux3(.a(add4_out), .b(add_sum_out), .s(pc_src), .result(r_multi3));

    regsBank RB(.w_enable(rf_we), .reset_rb(rst_n), .clock(clk), .regA(rs1), .regB(rs2), .regW(rw), .data_in_rb(r_multi2), .data_out_A(doA), .data_out_B(doB));
  
    ULA alu(.data_a(doA), .data_b(r_multi1), .ula_control(alu_cmd), .result(ULA_out), .alu_flags_ula(alu_flags) );

    adder4 add1(.data_in(pc_out),.data_out(add4_out));
    addsum addsum(.data_a(pc_out),.data_b(extended_instruction), .data_out(add_sum_out));

    decodIMM deco(.instruction_d(i_mem_data), .immediate(extended_instruction));
    


endmodule



module PC(
  input reset, en, clk_pc,
  input [63:0] data_in_pc,
  output [63:0] data_out_pc
 );

  reg [63:0] regpc;
  reg [1:0] counter;

  assign data_out_pc = regpc; 

  initial begin
    regpc <= 64'd0;
    counter = 2'b11;
  end

    
  always @(posedge clk_pc or negedge reset)begin
  if (counter == 2'b11) begin
    if(~reset) begin
      regpc <= 64'd0;
      counter <= 2'b00;
    end
    else if (en) begin
      regpc <= data_in_pc;
    end
    counter <= 6'b00;
  end
  counter <= counter + 1;
end




endmodule
module Multiplex(

input [63:0] a,
input [63:0] b,
input s,
output reg [63:0] result
);

always @(*) begin
  if(s) begin
    result = b;
  end else begin
    result = a;
  end
end
endmodule

module Mux5b(

input [4:0] a,
input [4:0] b,
input s,
output reg [4:0] result
);

always @(*) begin
  if(s) begin
    result = b;
  end else begin
    result = a;
  end
end
endmodule

module Register5b(clock, reset, r_enable, data_in, data_out);
//Esse modulo é a unidade de registrador, a celula que sera integrada para criar o banco
input clock, reset;
input r_enable;
input wire [4:0] data_in;
output [4:0] data_out;

reg [4:0] guarda5;



always @( * ) begin
if(reset)
 guarda5 <= 5'd0; 
if(r_enable)
  guarda5 <= data_in;
end

assign data_out = guarda5;


endmodule

module Register(clock, reset, r_enable, data_in, data_out);
//Esse modulo é a unidade de registrador, a celula que sera integrada para criar o banco
input clock, reset;
input r_enable;
input wire [63:0] data_in;
output  [63:0] data_out;

reg [63:0] guarda;



initial begin
    guarda = 64'd0;
end

always @(posedge clock or negedge reset) begin
  if(~reset)
    guarda <= 64'd0;
  else if(r_enable)
    guarda <= data_in;
  end
assign data_out = guarda;

endmodule

module regsBank( 
    input w_enable,reset_rb,
    input clock, 
    input [4:0] regA,
    input [4:0] regB,
    input [4:0] regW,
    input wire [63:0] data_in_rb,
    output [63:0] data_out_A,
    output [63:0] data_out_B
);

  genvar i;

  reg  entrada[32:0];
  wire [63:0] saida [32:0];

  assign saida[0] = 64'd0; // x0
    
      generate
          for (i = 1; i < 32; i = i + 1) begin
              Register xN (.clock(clock), .reset(reset_rb), .r_enable(i==regW), .data_in(data_in_rb),.data_out(saida[i]));
          end
      endgenerate

  always @(posedge clock) begin

    entrada[regW] <= w_enable;

  end


  //leitura de A

  assign data_out_A = saida[regA];

  assign data_out_B = saida[regB];
     
endmodule

module ULA(
  input signed [63:0] data_a,
  input signed [63:0] data_b,
  input [3:0] ula_control, // 00add || 01sub 
  output reg signed [63:0] result,
  output [3:0] alu_flags_ula
);

reg signed [63:0] add_result;
reg signed [63:0] sub_result;
reg [1:0] compare_result_signed;
reg [1:0] compare_result_unsigned;

// ULA operations
always @(*) begin
  case (ula_control)
    4'b0000: result = data_a + data_b; // addition
    4'b0001: result = data_a + data_b;
    4'b0010: result = data_a + data_b;
    4'b0100: result = data_a + data_b;
    4'b0101: result = data_a + data_b;
    4'b0011: result = data_a - data_b; // subtraction
    default: result = 64'd0; // invalid operation
  endcase
end

// Comparison for signed values
always @(*) begin
  if (result < 0) begin
    compare_result_signed = 2'b10; // data_a < data_b
  end else if (result == 0) begin
    compare_result_signed = 2'b01; // data_a == data_b
  end else begin
    compare_result_signed = 2'b00; // data_a > data_b
  end
end

// Comparison for unsigned values
always @(*) begin
  if (result < 0) begin
    compare_result_unsigned = 2'b10; // data_a < data_b
  end else if (data_a == data_b) begin
    compare_result_unsigned = 2'b01; // data_a == data_b
  end else begin
    compare_result_unsigned = 2'b00; // data_a > data_b
  end
end

// Flags
assign alu_flags_ula[0] = (compare_result_signed == 2'b01);
assign alu_flags_ula[1] = result[62];
assign alu_flags_ula[2] = (result[63]== 1);



endmodule

module adder4(
  input [63:0] data_in,
  output [63:0] data_out
);

  assign data_out =  data_in + 64'd4;

endmodule

module addsum(
  input [63:0] data_a,data_b,
  output [63:0] data_out
);

assign data_out = data_a + data_b;
endmodule

module decodIMM(
  input wire[31:0] instruction_d,
  output reg[63:0] immediate
);

  always @(*) begin
    case (instruction_d[6:0]) // opcode
      // S-type
      7'b0100011: immediate = {{52{instruction_d[31]}}, instruction_d[31:25], instruction_d[11:7]}; 
      // B-type
      7'b1100011: immediate = {{52{instruction_d[31]}}, instruction_d[7], instruction_d[30:25], instruction_d[11:8], 1'b0};
      // J-type
      7'b1101111: immediate = {{43{instruction_d[31]}}, instruction_d[19:12], instruction_d[12], instruction_d[20], instruction_d[30:21], 1'b0};
      // U-type
      7'b0010111: immediate = {{32{instruction_d[31]}}, instruction_d[31:12], 12'b0};
      // I-type
      default: immediate = instruction_d[31:20];
    endcase
  end

endmodule

module signextender(
  input [4:0] unextended,
  input clk,
  output reg [63:0] extended 
);

always@(posedge clk)
  begin 
    extended <= $signed(unextended);
  end
endmodule

