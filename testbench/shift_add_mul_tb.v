module shift_add_mul_tb;
    reg clk, rst, start;
    reg [3:0] a, b;
    wire [7:0] product;
    wire done;

    shift_add_mul uut (
        .clk(clk), .rst(rst), .start(start),
        .a(a), .b(b), .product(product), .done(done)
    );

    always #5 clk = ~clk;

    task do_mult;
        input [3:0] av;
        input [3:0] bv;
        begin
            @(posedge clk);
            a <= av; b <= bv; start <= 1;
            @(posedge clk);
            start <= 0;
            @(posedge done);
            @(posedge clk);
        end
    endtask
    initial begin
        clk = 0; rst = 0; start = 0; a = 0; b = 0;
        @(posedge clk); rst <= 1;
        @(posedge clk); rst <= 0;
        repeat (5) @(posedge clk);

          do_mult(4'd5, 4'd3);     // 15
          repeat (10) @(posedge clk);
          do_mult(4'd15, 4'd15);   // 225
          repeat (10) @(posedge clk);
          do_mult(4'd0, 4'd9);     // 0
          repeat (10) @(posedge clk);
          do_mult(4'd7, 4'd1);     // 7
          repeat (20) @(posedge clk);

          $display("Shift-add multiplier simulation complete.");
          $finish;
    end

    initial begin
        $dumpfile("shift_add_mul.vcd");
        $dumpvars(0, shift_add_mul_tb);
    end
endmodule
