module mux_4x1_2x1_tb;
reg clk;
reg rst;
reg [3:0] in;
reg [1:0] sel;
wire out;
integer i;
mux_4x1_2x1 uut (
 .clk(clk),
 .rst(rst),
 .in(in),
 .sel(sel),
 .out(out)
);
always #5 clk = ~clk;
initial begin
 clk = 0;
 rst = 1;
 in = 4'h0;
 sel = 2'b00;
 repeat (5) @(posedge clk);
 rst = 0;
 for (i = 0; i < 64; i = i + 1) begin
 @(posedge clk);
 {in, sel} <= i[5:0];
 end
 in = 4'b0000;
 sel = 2'b00;
 repeat (100) @(posedge clk);
 in = 4'b1111;
 sel = 2'b11;
 repeat (100) @(posedge clk);
 @(posedge clk);
 rst = 1;
 #3;
 rst = 0;
 repeat (50) @(posedge clk);
 $finish;
end
initial begin
 $dumpfile("mux_4x1_2x1.vcd");
 $dumpvars(0, mux_4x1_2x1_tb);
end
endmodule
