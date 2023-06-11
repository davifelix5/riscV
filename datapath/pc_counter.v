module pc_counter (
    input wire clk_in,
    input wire rst_n,
    output wire clk_out
);

reg [1:0] count;

always @(posedge clk_in or negedge rst_n) begin
    if (!rst_n) count <= 2'b11;
    else count <= count + 2'b01;
end

assign clk_out = count[1];

endmodule