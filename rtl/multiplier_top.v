 module multiplier_datapath (
 input wire clk,
 input wire rst,
 input wire ld_a,
 input wire ld_b,
 input wire ld_p,
 input wire clr_p,
 input wire dec_b,
 input wire [7:0] data_in,
 output wire b_zero,
 output reg [15:0] product
 );
 reg [7:0] multiplicand;
 reg [7:0] multiplier_reg;
always @(posedge clk or posedge rst) begin
 if (rst) begin
 multiplicand <= 8'b0;
 end else if (ld_a) begin
 multiplicand <= data_in;
 end
end
always @(posedge clk or posedge rst) begin
 if (rst) begin
 multiplier_reg <= 8'b0;
 end else if (ld_b) begin
 multiplier_reg <= data_in;
 end else if (dec_b) begin
 multiplier_reg <= multiplier_reg - 1'b1;
 end
end
always @(posedge clk or posedge rst) begin
 if (rst) begin
 product <= 16'b0;
 end else if (clr_p) begin
 product <= 16'b0;
 end else if (ld_p) begin
 product <= product + multiplicand;
 end
end
assign b_zero = (multiplier_reg == 8'b0);
endmodule

module multiplier_controller (
input wire clk,
input wire rst,
input wire start,
input wire b_zero,
output reg ld_a,
output reg ld_b,
output reg ld_p,
output reg clr_p,
output reg dec_b,
output reg done
);
parameter S_IDLE = 3'b000;
parameter S_LOAD = 3'b001;
parameter S_CHECK = 3'b010;
parameter S_ADD = 3'b011;
parameter S_DONE = 3'b100;
reg [2:0] state, next_state;
always @(posedge clk or posedge rst) begin
 if (rst) begin
 state <= S_IDLE;
 end else begin
 state <= next_state;
 end
end
always @(*) begin
 ld_a = 1'b0;
 ld_b = 1'b0;
 ld_p = 1'b0;
 clr_p = 1'b0;
 dec_b = 1'b0;
 done = 1'b0;
 next_state = state;
 case (state)
 S_IDLE: begin
 if (start) begin
 ld_a = 1'b1;
 next_state = S_LOAD;
 end
 end
 S_LOAD: begin
 ld_b = 1'b1;
 clr_p = 1'b1;
 next_state = S_CHECK;
 end
 S_CHECK: begin
 if (b_zero) begin
 next_state = S_DONE;
 end else begin
 next_state = S_ADD;
 end
 end
 S_ADD: begin
 ld_p = 1'b1;
 dec_b = 1'b1;
 next_state = S_CHECK;
 end
 S_DONE: begin
 done = 1'b1;
 if (!start) begin
 next_state = S_IDLE;
 end
 end
 default: begin
 next_state = S_IDLE;
 end
 endcase
end
endmodule

module multiplier_top (
input wire clk,
input wire rst,
input wire start,
input wire [7:0] data_in,
output wire [15:0] product,
output wire done
);
wire ld_a, ld_b, ld_p, clr_p, dec_b, b_zero;
multiplier_datapath dp (
 .clk(clk),
 .rst(rst),
 .ld_a(ld_a),
 .ld_b(ld_b),
 .ld_p(ld_p),
 .clr_p(clr_p),
 .dec_b(dec_b),
 .data_in(data_in),
 .b_zero(b_zero),
 .product(product)
);
multiplier_controller ctrl (
  .clk(clk),
  .rst(rst),
  .start(start),
  .b_zero(b_zero),
  .ld_a(ld_a),
  .ld_b(ld_b),
  .ld_p(ld_p),
  .clr_p(clr_p),
  .dec_b(dec_b),
  .done(done)
 );
 endmodule
