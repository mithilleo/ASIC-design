module mux_8x1_4x1_tb;
reg clk;
reg rst_n;
reg [7:0] in;
reg [2:0] sel;
wire out;
mux_8x1_4x1 uut (
 .clk(clk),
 .rst_n(rst_n),
 .in(in),
 .sel(sel),
 .out(out)
);
always #5 clk = ~clk;
initial begin
 clk = 0;
 rst_n = 0;
 in = 8'h00;
 sel = 3'b000;
 #15;
 rst_n = 1;
 #10;
 in = 8'b10101010;
 repeat (8) begin
 repeat (4) @(posedge clk);
 sel = sel + 1;
 end
 in = 8'b01010101;
 repeat (8) begin
 repeat (4) @(posedge clk);
 sel = sel + 1;
 end
 in = 8'b00000001;
 repeat (8) begin
 repeat (4) @(posedge clk);
 in = in << 1;
 sel = sel + 1;
 end
 repeat (15) begin
 repeat (4) @(posedge clk);
 in = $random;
 sel = $random;
 end
 @(posedge clk);
 rst_n = 0;
 #12;
 rst_n = 1;
 #40;
 $finish;
end
initial
begin
$dumpfile("mux_8x1_4x1.vcd");
$dumpvars(0,mux_8x1_4x1_tb);
end
endmodule
