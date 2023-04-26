module decoder5to32 (
    input wire EN,
    input wire[4:0] IN,
    output wire[31:0] OUT
);
  assign OUT[1] = EN & ~IN[4] & ~IN[3] & ~IN[2] & ~IN[1] & IN[0];
  assign OUT[2] = EN & ~IN[4] & ~IN[3] & ~IN[2] & IN[1] & ~IN[0];
  assign OUT[3] = EN & ~IN[4] & ~IN[3] & ~IN[2] & IN[1] & IN[0];
  assign OUT[4] = EN & ~IN[4] & ~IN[3] & IN[2] & ~IN[1] & ~IN[0];
  assign OUT[5] = EN & ~IN[4] & ~IN[3] & IN[2] & ~IN[1] & IN[0];
  assign OUT[6] = EN & ~IN[4] & ~IN[3] & IN[2] & IN[1] & ~IN[0];
  assign OUT[7] = EN & ~IN[4] & ~IN[3] & IN[2] & IN[1] & IN[0];
  assign OUT[8] = EN & ~IN[4] & IN[3] & ~IN[2] & ~IN[1] & ~IN[0];
  assign OUT[9] = EN & ~IN[4] & IN[3] & ~IN[2] & ~IN[1] & IN[0];
  assign OUT[10] = EN & ~IN[4] & IN[3] & ~IN[2] & IN[1] & ~IN[0];
  assign OUT[11] = EN & ~IN[4] & IN[3] & ~IN[2] & IN[1] & IN[0];
  assign OUT[12] = EN & ~IN[4] & IN[3] & IN[2] & ~IN[1] & ~IN[0];
  assign OUT[13] = EN & ~IN[4] & IN[3] & IN[2] & ~IN[1] & IN[0];
  assign OUT[14] = EN & ~IN[4] & IN[3] & IN[2] & IN[1] & ~IN[0];
  assign OUT[15] = EN & ~IN[4] & IN[3] & IN[2] & IN[1] & IN[0];
  assign OUT[16] = EN & IN[4] & ~IN[3] & ~IN[2] & ~IN[1] & ~IN[0];
  assign OUT[17] = EN & IN[4] & ~IN[3] & ~IN[2] & ~IN[1] & IN[0];
  assign OUT[18] = EN & IN[4] & ~IN[3] & ~IN[2] & IN[1] & ~IN[0];
  assign OUT[19] = EN & IN[4] & ~IN[3] & ~IN[2] & IN[1] & IN[0];
  assign OUT[20] = EN & IN[4] & ~IN[3] & IN[2] & ~IN[1] & ~IN[0];
  assign OUT[21] = EN & IN[4] & ~IN[3] & IN[2] & ~IN[1] & IN[0];
  assign OUT[22] = EN & IN[4] & ~IN[3] & IN[2] & IN[1] & ~IN[0];
  assign OUT[23] = EN & IN[4] & ~IN[3] & IN[2] & IN[1] & IN[0];
  assign OUT[24] = EN & IN[4] & IN[3] & ~IN[2] & ~IN[1] & ~IN[0];
  assign OUT[25] = EN & IN[4] & IN[3] & ~IN[2] & ~IN[1] & IN[0];
  assign OUT[26] = EN & IN[4] & IN[3] & ~IN[2] & IN[1] & ~IN[0];
  assign OUT[27] = EN & IN[4] & IN[3] & ~IN[2] & IN[1] & IN[0];
  assign OUT[28] = EN & IN[4] & IN[3] & IN[2] & ~IN[1] & ~IN[0];
  assign OUT[29] = EN & IN[4] & IN[3] & IN[2] & ~IN[1] & IN[0];
  assign OUT[30] = EN & IN[4] & IN[3] & IN[2] & IN[1] & ~IN[0];
  assign OUT[31] = EN & IN[4] & IN[3] & IN[2] & IN[1] & IN[0];
endmodule