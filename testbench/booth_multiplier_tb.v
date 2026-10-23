module booth_multiplier_tb;
    reg clk, rst, start;
    reg [3:0] multiplier, multiplicand;
    wire [7:0] product;
    wire done;

    booth_multiplier uut (
        .clk(clk), .rst(rst), .start(start),
        .multiplier(multiplier), .multiplicand(multiplicand),
        .product(product), .done(done)
    );

    always #5 clk = ~clk;

    task do_mult;
        input [3:0] mr;
        input [3:0] mc;
        begin
            @(posedge clk);
            multiplier <= mr; multiplicand <= mc; start <= 1;
            @(posedge clk);
            start <= 0;
            @(posedge done);
            @(posedge clk);
        end
    endtask

    initial begin
        clk = 0; rst = 0; start = 0; multiplier = 0; multiplicand = 0;
        @(posedge clk); rst <= 1;
        @(posedge clk); rst <= 0;
        repeat (5) @(posedge clk);

         do_mult(4'd3, 4'd3);
         repeat (10) @(posedge clk);
         do_mult(4'd5, 4'd2);
          repeat (10) @(posedge clk);
          do_mult(4'd7, 4'd1);
          repeat (10) @(posedge clk);
          do_mult(4'd0, 4'd9);
          repeat (10) @(posedge clk);
          do_mult(4'hE, 4'd3);   // -2 * 3
          repeat (10) @(posedge clk);
          do_mult(4'hE, 4'hE);   // -2 * -2
          repeat (20) @(posedge clk);

          $display("Booth multiplier simulation complete.");
          $finish;
    end

    initial begin
        $dumpfile("booth_multiplier.vcd");
        $dumpvars(0, booth_multiplier_tb);
    end
endmodule
