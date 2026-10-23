module mux_2x1 (
input wire clk,
input wire rst_n,
input wire in0,
input wire in1,
input wire sel,
output reg out
);
reg mux_comb_out;
always @(*) begin
 case (sel)
 1'b0: mux_comb_out = in0;
 default: mux_comb_out = in1;
 endcase
end
always @(posedge clk) begin
 if (!rst_n) begin
 out <= 1'b0;
 end else begin
 out <= mux_comb_out;
 end
end
endmodule
