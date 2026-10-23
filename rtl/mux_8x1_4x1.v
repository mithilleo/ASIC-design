module mux_8x1_4x1 (
input wire clk,
input wire rst_n,
input wire [7:0] in,
input wire [2:0] sel,
output reg out
);
wire mux_low_out;
wire mux_high_out;
wire mux_final_out;
mux_4x1 u_mux_low (
 .in(in[3:0]),
 .sel(sel[1:0]),
 .out(mux_low_out)
);
mux_4x1 u_mux_high (
 .in(in[7:4]),
 .sel(sel[1:0]),
 .out(mux_high_out)
);
mux_2x1 u_mux_top (
 .in0(mux_low_out),
 .in1(mux_high_out),
 .sel(sel[2]),
 .out(mux_final_out)
);
always @(posedge clk or negedge rst_n) begin
 if (!rst_n) begin
 out <= 1'b0;
 end else begin
 out <= mux_final_out;
 end
end
endmodule

module mux_4x1 (
input wire [3:0] in,
input wire [1:0] sel,
output wire out
);
assign out = (sel == 2'b00) ? in[0] :
 (sel == 2'b01) ? in[1] :
 (sel == 2'b10) ? in[2] : in[3];
endmodule

module mux_2x1 (
input wire in0,
input wire in1,
input wire sel,
output wire out
);
assign out = sel ? in1 : in0;
endmodule
