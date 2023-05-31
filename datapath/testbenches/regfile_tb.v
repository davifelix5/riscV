module regfile_tb;

reg [4:0] Ra, Rb, Rw;
reg WE, CLK;
reg [63:0] Din;
wire [63:0] Da, Db;
 
regfile RF (
    .Ra(Ra),
    .Rb(Rb),
    .WE(WE),
    .Din(Din),
    .Rw(Rw),
    .CLK(CLK),
    .Da(Da),
    .Db(Db)
);

initial begin
    $display("Ra | Rb | WE | Din | Rw | Da | Db");
    $monitor("%d | %d | %d | %d | %d | %d | %d", Ra, Rb, WE, Din, Rw, Da, Db);
    CLK = 0;
    WE = 0;
    #10;
    Ra = 0;
    Rb = 1;
    WE = 1;
    Din = 234;
    Rw = 1;
    #10;
    Ra = 18;
    Din = 672;
    Rw = 18;
    #100;
    $finish;
end

always #5 CLK = ~CLK;

endmodule