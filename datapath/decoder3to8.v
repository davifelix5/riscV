module decoder3to8 (
  input wire[2:0] IN,
  input wire EN,
  output wire[7:0] OUT
);

  assign OUT[0] = EN & ~IN[2] & ~IN[1] & ~IN[0];
  assign OUT[1] = EN & ~IN[2] & ~IN[1] & IN[0];
  assign OUT[2] = EN & ~IN[2] & IN[1] & ~IN[0];
  assign OUT[3] = EN & ~IN[2] & IN[1] & IN[0];
  assign OUT[4] = EN & IN[2] & ~IN[1] & ~IN[0];
  assign OUT[5] = EN & IN[2] & ~IN[1] & IN[0];
  assign OUT[6] = EN & IN[2] & IN[1] & ~IN[0];
  assign OUT[7] = EN & IN[2] & IN[1] & IN[0];

endmodule