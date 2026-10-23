module updowncounter_4bit_tb;
reg clk;
reg rst;
reg up_dn;
wire [3:0] count;
updowncounter_4bit uut (
 .clk(clk),
 .rst(rst),
 .up_dn(up_dn),
 .count(count)
);
always #5 clk = ~clk;
initial begin
 clk = 0;
 rst = 0;
 up_dn = 0;
 #20;

 rst = 1;
 up_dn = 1;
 #200;

 up_dn = 0;
 #200;

 rst = 0;
 up_dn = 0;
 #5000;
 $finish;
end
initial begin
$dumpfile("updowncounter_4bit.vcd");
 $dumpvars(0, updowncounter_4bit_tb);
end
endmodule
