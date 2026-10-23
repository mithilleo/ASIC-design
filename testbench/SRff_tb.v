module SRff_tb;
reg clk;
reg rst;
reg s;
reg r;
wire q;
wire q_bar;
SRff uut (
 .clk(clk),
 .rst(rst),
 .s(s),
 .r(r),
 .q(q),
 .q_bar(q_bar)
);
always #5 clk = ~clk;
initial begin
 clk = 0;
 rst = 1;
 s = 0;
 r = 0;
 @(posedge clk);
 s = 1; r = 1;
 @(posedge clk);
 rst = 0;
 s = 1; r = 0;
 @(posedge clk);
 s = 0; r = 0;
 @(posedge clk);
 s = 0; r = 1;
 @(posedge clk);
 s = 0; r = 0;
 @(posedge clk);
 s = 1; r = 1;
 @(posedge clk);
 rst = 1;
 @(posedge clk);
 rst = 0;
 s = 1'bx; r = 1'b0;
 @(posedge clk);
 s = 1'bx; r = 1'bx;
 @(posedge clk);
 s = 1; r = 0;
 @(posedge clk);
 s = 0; r = 1;
 @(posedge clk);
 s = 1; r = 1;
 @(posedge clk);
 s = 0; r = 0;
 @(posedge clk);
 repeat (50) @(posedge clk);
 $finish;
end

initial begin
 $dumpfile("SRff.vcd");
 $dumpvars(0, SRff_tb);
end
endmodule
