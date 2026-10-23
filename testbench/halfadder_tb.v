module halfadder_tb;
reg clk;
reg rst;
reg a;
reg b;
wire sum;
wire carry;
halfadder uut (
 .clk(clk),
 .rst(rst),
 .a(a),
 .b(b),
 .sum(sum),
 .carry(carry)
);
always #5 clk = ~clk;
initial begin
 clk = 0;
 rst = 1;
 a = 0;
 b = 0;
 #12;
 rst = 0;
 #8;
 a = 0; b = 0;
 #10;
 a = 0; b = 1;
 #10;
 a = 1; b = 0;
 #10;
 a = 1; b = 1;
 #10;
 a = 0; b = 0;
 #10;
 rst = 1;
 #8;
 a = 0; b = 0;
 #10;
 a = 0; b = 1;
 #10;
 a = 1; b = 0;
 #10;
 a = 1; b = 1;
 #10;
 a = 0; b = 0;
 #10;
 $finish;
end
initial
 begin
 $dumpfile("halfadder.vcd");
 $dumpvars(0,halfadder_tb);
 end
endmodule
