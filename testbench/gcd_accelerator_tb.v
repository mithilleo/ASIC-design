module gcd_accelerator_tb;
    reg clk, rst, start;
    reg [7:0] u, v;
    wire [7:0] gcd;
    wire done;

    gcd_accelerator uut (
          .clk(clk), .rst(rst), .start(start),
          .u(u), .v(v), .gcd(gcd), .done(done)
    );

    always #5 clk = ~clk;

    task do_gcd;
        input [7:0] uv;
        input [7:0] vv;
        begin
            @(posedge clk);
            u <= uv; v <= vv; start <= 1;
            @(posedge clk);
            start <= 0;
            @(posedge done);
            @(posedge clk);   // done is still high through this edge
            @(posedge clk);   // gcd register has now captured X (done-enabled)
        end
    endtask

    initial begin
        clk = 0; rst = 0; start = 0; u = 0; v = 0;
        @(posedge clk); rst <= 1;
        @(posedge clk); rst <= 0;
        repeat (5) @(posedge clk);

          do_gcd(8'd48, 8'd18);    // gcd = 6
          repeat (10) @(posedge clk);
          do_gcd(8'd17, 8'd5);     // coprime, gcd = 1
          repeat (10) @(posedge clk);
          do_gcd(8'd100, 8'd75);   // gcd = 25
          repeat (10) @(posedge clk);
          do_gcd(8'd7,   8'd7);    // equal operands, gcd = 7
          repeat (10) @(posedge clk);
          do_gcd(8'd255, 8'd1);    // gcd = 1
          repeat (20) @(posedge clk);

          $display("GCD accelerator simulation complete.");
          $finish;
    end

    initial begin
        $dumpfile("gcd_accelerator.vcd");
        $dumpvars(0, gcd_accelerator_tb);
    end
endmodule
