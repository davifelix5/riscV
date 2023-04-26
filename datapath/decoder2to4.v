module decoder2to4 (
  input wire[1:0] IN,
  input wire EN,
  output wire[3:0] OUT
);

  assign OUT[0] = EN & ~IN[1] & ~IN[0];
  assign OUT[1] = EN & ~IN[1] & IN[0];
  assign OUT[2] = EN & IN[1] & ~IN[0];
  assign OUT[3] = EN & IN[1] & IN[0];

endmodule