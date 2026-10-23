module multiplier_top_tb;
reg clk;
reg rst;
reg start;
reg [7:0] data_in;
wire [15:0] product;
wire done;
multiplier_top uut (
 .clk(clk),
 .rst(rst),
 .start(start),
 .data_in(data_in),
 .product(product),
 .done(done)
);
always #5 clk = ~clk;
task do_mult;
 input [7:0] a;
 input [7:0] b;
 input hold_start;
 begin
 @(posedge clk);
 data_in <= a;
 start <= 1;

 @(posedge clk);
 data_in <= b;

 if (!hold_start) begin
 start <= 0;
 end

 @(posedge done);

 if (hold_start) begin
 @(posedge clk);
 start <= 0;
 end

 @(posedge clk);
 end
endtask
initial begin
 clk = 0;
 rst = 0;
 start = 0;
 data_in = 8'h00;
 @(posedge clk);
 rst <= 1;
 @(posedge clk);
 rst <= 0;
 repeat(50) @(posedge clk);
 do_mult(8'hFF, 8'hFF, 1);
 repeat(50) @(posedge clk);
 do_mult(8'hFF, 8'h02, 0);
 repeat(50) @(posedge clk);
 do_mult(8'hAA, 8'h55, 0);
 repeat(50) @(posedge clk);
 do_mult(8'h55, 8'hAA, 0);
 repeat(50) @(posedge clk);
 do_mult(8'hAA, 8'h00, 0);
 repeat(50) @(posedge clk);
 do_mult(8'h00, 8'h0F, 0);
 repeat(50) @(posedge clk);
 @(posedge clk);
 uut.ctrl.state = 3'b111;
 repeat(2) @(posedge clk);
 rst <= 1;
 @(posedge clk);
 rst <= 0;

 repeat(100) @(posedge clk);
 $display("Simulation complete.");
 $finish;
end
initial begin
 $dumpfile("multiplier_top.vcd");
 $dumpvars(0, multiplier_top_tb);
end
endmodule
