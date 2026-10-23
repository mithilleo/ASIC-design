module halfadder (
input clk,
input rst,
input a,
input b,
output reg sum,
output reg carry
);
reg a1;
reg b1;

always @(posedge clk or posedge rst)
begin
 if (rst)
 begin a1 <= 1'b0;
 b1 <= 1'b0;
 sum <= 1'b0;
 carry <= 1'b0;
 end
 else
 begin
 a1 <= a;
 b1 <= b;

 sum <= a1 ^ b1;
 carry <= a1 & b1;
 end
end
endmodule

module fulladder(
input A,
input B,
input Cin,
input clk,
input rst,
output reg Sum,
output reg Cout
);
wire s1, c1, c2;
wire sum_int, cout_int;
halfadder HA1 (.clk(clk), .rst(rst), .a(A), .b(B), .sum(s1), .carry(c1));
halfadder HA2 (.clk(clk), .rst(rst), .a(s1), .b(Cin), .sum(sum_int), .carry(c2));
assign cout_int = c1 | c2;
always @(posedge clk or posedge rst) begin
 if (rst) begin
 Sum <= 1'b0;
 Cout <= 1'b0;
 end else begin
 Sum <= sum_int;
 Cout <= cout_int;
 end
end
endmodule
