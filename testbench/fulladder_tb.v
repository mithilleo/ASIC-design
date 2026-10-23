module fulladder_tb;
reg A;
reg B;
reg Cin;
reg clk;
reg rst;
wire Sum;
wire Cout;
integer i;
fulladder uut (
 .A(A),
 .B(B),
 .Cin(Cin),
 .clk(clk),
 .rst(rst),
 .Sum(Sum),
 .Cout(Cout)
);
always #5 clk = ~clk;
initial begin
 clk = 0;
 rst = 1;
 A = 0;
 B = 0;
 Cin = 0;
 #3;
 rst = 0;
 for (i = 0; i < 8; i = i + 1) begin
 @(posedge clk);
 {A, B, Cin} = i[2:0];
 end
 A = 0;
 B = 0;
 Cin = 0;
 repeat (20) @(posedge clk);
 for (i = 7; i >= 0; i = i - 1) begin
 @(posedge clk);
 {A, B, Cin} = i[2:0];
 end
 A = 1;
 B = 1;
 Cin = 1;
 repeat (20) @(posedge clk);
 rst = 1;
 @(posedge clk);
 rst = 0;
 {A, B, Cin} = 3'b101;
 @(posedge clk);
 {A, B, Cin} = 3'b010;
 @(posedge clk);
 A = 0;
 B = 0;
 Cin = 0;
 #50;
 $finish;
end
initial begin
 $dumpfile("fulladder.vcd");
 $dumpvars(0, fulladder_tb);
end
endmodule
