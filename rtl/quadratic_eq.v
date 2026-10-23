module quadratic_eq (input clk, rst, A, B, C, X, output reg [1:0] y);
 reg [1:0] y_r;
 always @ (*)
 y_r <= X*(A+B) + C;
 always @ (posedge clk)
 begin
 if (rst) y<=0;
 else y<=y_r;
 end
endmodule
