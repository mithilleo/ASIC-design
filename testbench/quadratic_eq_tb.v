module quadratic_eq_tb;
reg clk;
reg rst;
reg A;
reg B;
reg C;
reg X;
wire [1:0] y;
integer i;
quadratic_eq uut (
 .clk(clk),
 .rst(rst),
 .A(A),
 .B(B),
 .C(C),
 .X(X),
 .y(y)
);
always #5 clk = ~clk;
initial begin
 clk = 0;
 rst = 1;
 A = 0;
 B = 0;
 C = 0;
 X = 0;
 #20;
 rst = 0;
 #20;
 for (i = 0; i < 16; i = i + 1) begin
 {X, A, B, C} = i[3:0];
 #50;
 end
 rst = 1;
 A = 0;
 B = 0;
 C = 0;
 X = 0;
 #50;

 rst = 0;
 #2000;
 $finish;
end
initial begin
$dumpfile("quadratic_eq.vcd");
 $dumpvars(0, quadratic_eq_tb);
end
endmodule
