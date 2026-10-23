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
 begin
 a1 <= 1'b0;
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
