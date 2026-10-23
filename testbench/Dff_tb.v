module Dff_tb;
reg clk;
reg rst;
reg d;
wire q;
wire q_bar;
Dff uut (
 .clk(clk),
 .rst(rst),
 .d(d),
 .q(q),
 .q_bar(q_bar)
);
always #5 clk = ~clk;
initial begin
 clk = 0;
 rst = 1;
 d = 0;
 #20;

 rst = 0;
 #50;

 d = 1;
 #100;

 d = 0;
 #100;

 rst = 1;
 #30;

 rst = 0;
 #100;
 $finish;
end
initial begin
$dumpfile("Dff.vcd");
 $dumpvars(0, Dff_tb);
end
endmodule
