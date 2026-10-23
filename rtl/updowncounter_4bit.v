module updowncounter_4bit (
input wire clk,
input wire rst,
input wire up_dn,
output reg [3:0] count
);
always @(posedge clk or negedge rst) begin
 if (!rst) begin
 count <= 4'b0000;
 end else begin
 if (up_dn) begin
 count <= count + 1'b1;
 end else begin
 count <= count - 1'b1;
 end
 end
end
endmodule
