module uc_asm (
  input wire reset,
  input wire clk,
  input wire[6:0] opcode,
  output reg WE_RF,
  output reg WE_MEM,
  output reg[1:0] RF_din_sel,
  output reg ULA_din2_sel,
  output reg load_pc,
  output reg load_ir,
  output reg pc_next_sel,
  output reg pc_adder_sel
);

  parameter FETCH = 3'b000,
            DECODE = 3'b001,
            EXECUTE_ADDSUB = 3'b010,
            EXECUTE_ADDI = 3'b011,
            WRITE_BACK = 3'b100;

  reg[2:0] current_state, next_state;

  always @(posedge clk or posedge reset) begin
    if (reset) begin
      current_state <= FETCH;
    end
    else begin
      current_state <= next_state;
    end
  end

  always @(current_state) begin
    case (current_state)
      FETCH: begin
        next_state <= DECODE;
      end

      DECODE: begin
        if (opcode == 7'b0010011) begin
          next_state <= EXECUTE_ADDI;
        end
        else begin
          next_state <= EXECUTE_ADDSUB;
        end
      end

      EXECUTE_ADDSUB: begin
        next_state <= WRITE_BACK; 
      end

      EXECUTE_ADDI: begin
        next_state <= WRITE_BACK; 
      end

      default: begin
        next_state <= FETCH;
      end
    endcase
  end

    always @(current_state) begin
      case (current_state)
        FETCH: begin
          // PC = PC + 4
          // IR = INSTRUCTION_MEMORY[PC]
          pc_next_sel = 1'b0;
          load_ir = 1'b1;
          load_pc = 1'b1;
          WE_RF = 1'b0;
          WE_MEM = 1'b1;
          RF_din_sel = 1'b0;
          ULA_din2_sel = 1'b0;
        end 
        DECODE: begin
          load_ir = 1'b0;
          load_pc = 1'b0;
        end
        EXECUTE_ADDSUB: begin
          RF_din_sel = 2'b01;
          ULA_din2_sel = 1'b0;
        end
        EXECUTE_ADDI: begin
          RF_din_sel = 2'b01;
          ULA_din2_sel = 1'b1;
        end
        WRITE_BACK: begin
          WE_RF = 1'b1;
        end
      endcase
    end
  
endmodule