module SRff (
input wire clk,
input wire rst,
input wire s,
input wire r,
output reg q,
output wire q_bar
);
assign q_bar = ~q;
always @(posedge clk) begin
 if (rst) begin
 q <= 1'b0;
 end
 else begin
 case ({s, r})
 2'b00: q <= q;
 2'b01: q <= 1'b0;
 2'b10: q <= 1'b1;
 2'b11: q <= 1'bx;
 default: q <= 1'b0;
 endcase
 end
end
endmodule
