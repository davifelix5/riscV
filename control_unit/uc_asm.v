module uc_asm (
  input wire reset,
  input wire clk,
  input wire[6:0] opcode,
  output reg WE_RF,
  output reg WE_MEM,
  output reg[1:0] RF_din_sel,
  output reg ULA_din2_sel,
  output reg addr_sel,
  output reg load_pc,
  output reg load_ir,
  output reg pc_next_sel,
  output reg pc_adder_sel
);

  parameter FETCH = 4'd1,
             DECODE = 4'd2,
             EXECUTE_ADDSUB = 4'd3,
             EXECUTE_ADDI = 4'd4,
             EXECUTE_LOAD = 4'd5,
             EXECUTE_STORE = 4'd6,
             EXECUTE_JAL = 4'd7,
             EXECUTE_JALR = 4'd8,
             WRITE_BACK_ADDI = 4'd9,
             WRITE_BACK_ADDSUB = 4'd10,
             WRITE_BACK_LOAD = 4'd11,
             WRITE_BACK_STORE = 4'd12,
             WRITE_BACK_JAL = 4'd13,
             WRITE_BACK_JALR = 4'd14;

  reg[3:0] current_state, next_state;

  always @(posedge clk or posedge reset) begin
    if (reset) begin
      current_state <= FETCH;
    end
    else begin
      current_state <= next_state;
    end
  end

  always @(current_state, opcode) begin
	 next_state = 4'b0000;
    case (current_state)
      FETCH: begin
        next_state = DECODE;
      end

      DECODE: begin
        case (opcode)
          7'b0010011: next_state = EXECUTE_ADDI;
          7'b0000011: next_state = EXECUTE_LOAD;
          7'b0100011: next_state = EXECUTE_STORE;
          7'b1101111: next_state = EXECUTE_JAL;
          7'b1100111: next_state = EXECUTE_JALR;
          default: next_state = EXECUTE_ADDSUB;
        endcase
      end

      EXECUTE_ADDSUB: begin
        next_state = WRITE_BACK_ADDSUB; 
      end

      EXECUTE_ADDI: begin
        next_state = WRITE_BACK_ADDI; 
      end

      EXECUTE_LOAD: begin
        next_state = WRITE_BACK_LOAD; 
      end

      EXECUTE_STORE: begin
        next_state = WRITE_BACK_STORE; 
      end

      EXECUTE_JAL: begin
        next_state = WRITE_BACK_JAL;
      end

      EXECUTE_JALR: begin
        next_state = WRITE_BACK_JALR;
      end

      WRITE_BACK_ADDSUB, WRITE_BACK_ADDI,
      WRITE_BACK_LOAD, WRITE_BACK_STORE,
      WRITE_BACK_JAL, WRITE_BACK_JALR: begin
        next_state = FETCH;
      end

      default: begin
        next_state = 4'b0000;
      end
    endcase
  end

  always @(current_state) begin
      load_ir = 1'b0;
      load_pc = 1'b0;
      WE_RF = 1'b0;
      RF_din_sel = 2'b00;
      ULA_din2_sel = 1'b0;
      pc_next_sel = 1'b0;
      pc_adder_sel = 1'b0;
      WE_MEM = 1'b0;
      addr_sel = 1'b0;
			case (current_state)
			  FETCH: begin
				 load_ir = 1'b1;
				 addr_sel = 1'b1;
			  end 
			  EXECUTE_ADDSUB: begin
         RF_din_sel = 2'b01;
			  end
			  EXECUTE_ADDI: begin
         RF_din_sel = 2'b01;
				 ULA_din2_sel = 1'b1;
			  end
			  WRITE_BACK_ADDI: begin
         load_pc = 1'b1;
			   WE_RF = 1'b1;
         RF_din_sel = 2'b01;
				 ULA_din2_sel = 1'b1;
			  end
        WRITE_BACK_ADDSUB: begin
         load_pc = 1'b1;
			   WE_RF = 1'b1;
         RF_din_sel = 2'b01;
			  end
        EXECUTE_LOAD: begin
          ULA_din2_sel = 1'b1;
          RF_din_sel = 2'b00;
          addr_sel = 1'b0;
			  end
        WRITE_BACK_LOAD: begin
          load_pc = 1'b1;
          ULA_din2_sel = 1'b1;
          RF_din_sel = 2'b00;
          addr_sel = 1'b0;
          WE_RF = 1'b1;
			  end
			  EXECUTE_STORE: begin
          ULA_din2_sel = 1'b1;
          addr_sel = 1'b0;
			  end
			  WRITE_BACK_STORE: begin
          load_pc = 1'b1;
          ULA_din2_sel = 1'b1;
          addr_sel = 1'b0;
          WE_MEM = 1'b1;
			  end
        EXECUTE_JAL: begin
          RF_din_sel = 2'b10;
          pc_adder_sel = 1'b1;
          pc_next_sel = 1'b1;
        end
        WRITE_BACK_JAL: begin
          load_pc = 1'b1;
          RF_din_sel = 2'b10;
          pc_adder_sel = 1'b1;
          pc_next_sel = 1'b1;
          WE_RF = 1'b1;
        end
        EXECUTE_JALR: begin
          RF_din_sel = 2'b10;
          pc_adder_sel = 1'b0;
          pc_next_sel = 1'b1;
        end
        WRITE_BACK_JALR: begin
          load_pc = 1'b1;
          RF_din_sel = 2'b10;
          pc_adder_sel = 1'b0;
          pc_next_sel = 1'b1;
          WE_RF = 1'b1;
        end
        default: begin 
          load_ir = 1'b0;
          load_pc = 1'b0;
          WE_RF = 1'b0;
          RF_din_sel = 2'b00;
          ULA_din2_sel = 1'b0;
          pc_next_sel = 1'b0;
          pc_adder_sel = 1'b0;
          WE_MEM = 1'b0;
          addr_sel = 1'b0;
        end
			endcase
		end
  
endmodule