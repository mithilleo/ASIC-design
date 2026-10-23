module mux_2x1_tb;

reg clk;
reg rst_n;
reg in0;
reg in1;
reg sel;
wire out;
integer i;
mux_2x1 uut (
 .clk(clk),
 .rst_n(rst_n),
 .in0(in0),
 .in1(in1),
 .sel(sel),
 .out(out)
);
always #5 clk = ~clk;
initial begin
 clk = 0;
 rst_n = 0;
 in0 = 0;
 in1 = 0;
 sel = 0;
 #3;
 rst_n = 1;
 for (i = 0; i < 8; i = i + 1) begin
 @(posedge clk);
 {in1, in0, sel} = i[2:0];
 end
 in0 = 0;
 in1 = 0;
 sel = 0;
 repeat (20) @(posedge clk);
 rst_n = 0;
 @(posedge clk);
 rst_n = 1;
 for (i = 7; i >= 0; i = i - 1) begin
 @(posedge clk);
 {in1, in0, sel} = i[2:0];
 end
 in0 = 1;
 in1 = 1;
 sel = 1;
 repeat (20) @(posedge clk);
 #20;
 $finish;
end
initial begin
 $dumpfile("mux_2x1.vcd");
 $dumpvars(0, mux_2x1_tb);
end
endmodule
