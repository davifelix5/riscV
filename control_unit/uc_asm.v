module uc_asm (
  input wire clk, rst_n,
  input wire[6:0] opcode,
  output reg rf_we, d_mem_we,
  input[3:0] alu_flags,
  output reg[3:0] alu_cmd,
  output reg alu_src, pc_src, rf_src
);

  parameter FETCH = 4'd1,
            DECODE = 4'd2,
            EXECUTE_ADDSUB = 4'd3,
            EXECUTE_ADDI = 4'd4,
            EXECUTE_LOAD = 4'd5,
            EXECUTE_STORE = 4'd6,
            EXECUTE_BRANCH = 4'd7,
            WRITE_BACK = 4'd8;

  reg[3:0] current_state, next_state;

  always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
      current_state <= FETCH;
    end
    else begin
      current_state <= next_state;
    end
  end

  always @(current_state, opcode) begin
	 next_state = 5'b0000;
    case (current_state)
      FETCH: begin
        next_state = DECODE;
      end

      DECODE: begin
        case (opcode)
          7'b0010011: next_state = EXECUTE_ADDI;
          7'b0000011: next_state = EXECUTE_LOAD;
          7'b0100011: next_state = EXECUTE_STORE;
          7'b1100011: next_state = EXECUTE_BRANCH;
          default: next_state = EXECUTE_ADDSUB;
        endcase
      end

      EXECUTE_ADDSUB,
      EXECUTE_ADDI,
      EXECUTE_LOAD,
      EXECUTE_STORE,
      EXECUTE_BRANCH: begin
        next_state = WRITE_BACK; 
      end

      WRITE_BACK: begin
        next_state = FETCH;
      end

      default: begin
        next_state = 4'b0;
      end
    endcase
  end

  always @(current_state) begin
      rf_we = 1'b0;
      d_mem_we = 1'b0;
      rf_src = 1'b0;
      alu_src = 1'b0;
      pc_src = 1'b0;
			case (current_state)
			  EXECUTE_ADDSUB: begin
          rf_src = 1'b0;
          alu_src = 1'b0;
          rf_we = 1'b1;
          alu_cmd = 4'b0000;
			  end
			  EXECUTE_ADDI: begin
         rf_src = 1'b0;
				 alu_src = 1'b1;
         rf_we = 1'b1;
         alu_cmd = 4'b0001;
			  end
        EXECUTE_LOAD: begin
          alu_src = 1'b1;
          rf_src = 1'b1;
          rf_we = 1'b1;
          alu_cmd = 4'b0001;
			  end
			  EXECUTE_STORE: begin
          alu_src = 1'b1;
          d_mem_we = 1'b1;
          alu_cmd = 4'b0010;
			  end
        EXECUTE_BRANCH: begin
          alu_cmd = 4'b0011;
        end
        default: begin 
          rf_we = 1'b0;
          d_mem_we = 1'b0;
          rf_src = 1'b0;
          alu_src = 1'b0;
          pc_src = 1'b0;
        end
			endcase
		end
  
endmodule