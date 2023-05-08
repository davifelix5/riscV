module decoder5to32 (
    input wire EN,
    input wire[4:0] IN,
    output wire[31:0] OUT
);

  wire[3:0] EN1;

  decoder2to4 DEC2_4 (
    .IN(IN[4:3]),
    .OUT(EN1),
    .EN(EN)
  );

  decoder3to8 DEC3_8__1 (
    .IN(IN[2:0]),
    .OUT(OUT[31:24]),
    .EN(EN1[3])
  );

  decoder3to8 DEC3_8__2 (
    .IN(IN[2:0]),
    .OUT(OUT[23:16]),
    .EN(EN1[2])
  );

  decoder3to8 DEC3_8__3 (
    .IN(IN[2:0]),
    .OUT(OUT[15:8]),
    .EN(EN1[1])
  );

  decoder3to8 DEC3_8__4 (
    .IN(IN[2:0]),
    .OUT(OUT[7:0]),
    .EN(EN1[0])
  );
  
endmodule