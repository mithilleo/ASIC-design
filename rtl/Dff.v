module SRff (
input clk,
input rst,
input s,
input r,
output reg q,
output reg q_bar
);
always @(posedge clk) begin
 if (rst) begin
 q <= 1'b0;
 q_bar <= 1'b1;
 end else begin
 q <= s | (~r & q);
 q_bar <= r | (~s & q_bar);
 end
end
endmodule

module Dff (
input clk,
input rst,
input d,
output q,
output q_bar
);
wire s;
wire r;
assign s = d;
assign r = ~d;
SRff u_sr (
 .clk(clk),
 .rst(rst),
 .s(s),
 .r(r),
 .q(q),
 .q_bar(q_bar)
);
endmodule
