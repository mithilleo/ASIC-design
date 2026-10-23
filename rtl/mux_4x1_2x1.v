module mux_2x1 (
input wire clk,
input wire rst,
input wire in0,
input wire in1,
input wire sel,
output reg out
);
always @(posedge clk or posedge rst) begin
 if (rst) begin
 out <= 1'b0;
 end else begin
 case (sel)
 1'b0: out <= in0;
 default: out <= in1;
 endcase
 end
end
endmodule

module mux_4x1_2x1 (
input wire clk,
input wire rst,
input wire [3:0] in,
input wire [1:0] sel,
output reg out
);
wire mux_low_out;
wire mux_high_out;
wire mux_final_out;
mux_2x1 u_mux_low (
 .clk(clk),
 .rst(rst),
 .in0(in[0]),
 .in1(in[1]),
 .sel(sel[0]),
 .out(mux_low_out)
);
mux_2x1 u_mux_high (
 .clk(clk),
 .rst(rst),
 .in0(in[2]),
 .in1(in[3]),
 .sel(sel[0]),
 .out(mux_high_out));
mux_2x1 u_mux_top (
 .clk(clk),
 .rst(rst),
 .in0(mux_low_out),
 .in1(mux_high_out),
 .sel(sel[1]),
 .out(mux_final_out)
);
always @(posedge clk or posedge rst) begin
 if (rst) begin
 out <= 1'b0;
 end else begin
 out <= mux_final_out;
 end
end
endmodule
