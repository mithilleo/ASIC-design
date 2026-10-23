 module booth_controller (
     input wire clk,
     input wire rst,
     input wire start,
     input wire [1:0] q_dec,
     output reg load,
     output reg sub,
     output reg add,
     output reg shift,
     output reg done
);
    reg [2:0] state, next_state;
    localparam IDLE = 3'b000, LOAD = 3'b001, CHECK = 3'b010, OPERATE = 3'b011, SHIFT =
3'b100, DONE = 3'b101;
    reg [2:0] count;

     always @(posedge clk or posedge rst) begin
         if (rst) begin
             state <= IDLE;
             count <= 3'd0;
         end else begin
             state <= next_state;
             if (state == LOAD)
                 count <= 3'd4;
             else if (state == SHIFT)
                 count <= count - 3'd1;
         end
     end

     always @(*) begin
         next_state = state;
         load = 1'b0;
         sub = 1'b0;
         add = 1'b0;
         shift = 1'b0;
         done = 1'b0;

         case (state)
             IDLE: begin
                 if (start) next_state = LOAD;
             end
             LOAD: begin
                 load = 1'b1;
                 next_state = CHECK;
             end
             CHECK: begin
                 if (count == 3'd0) begin
                      next_state = DONE;
                 end else begin
                      next_state = OPERATE;
                 end
             end
             OPERATE: begin
                 next_state = SHIFT;
             end
             SHIFT: begin
                 shift = 1'b1;
                 next_state = CHECK;
             end
             DONE: begin
                 done = 1'b1;
                 if (!start) next_state = IDLE;
             end
             default: next_state = IDLE;
         endcase
    end
endmodule

module booth_datapath (
     input wire clk,
     input wire rst,
     input wire load,
     input wire sub,
     input wire add,
     input wire shift,
     input wire [3:0] multiplier_in,
     input wire [3:0] multiplicand_in,
     output wire [1:0] q_dec,
     output reg [7:0] product
);
     reg [4:0] a;
     reg [3:0] q;
     reg q_1;
     reg [3:0] m;

     assign q_dec = {q[0], q_1};

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            a <= 5'd0;
            q <= 4'd0;
            q_1 <= 1'b0;
            m <= 4'd0;
            product <= 8'd0;
        end else if (load) begin
            a <= 5'd0;
            q <= multiplier_in;
            q_1 <= 1'b0;
            m <= multiplicand_in;
        end else if (shift) begin
            {a, q, q_1} <= {a[4], a, q};
        end else begin
            if (q_dec == 2'b01) begin
                a <= a + {m[3], m};
            end else if (q_dec == 2'b10) begin
                a <= a - {m[3], m};
            end
            product <= {a[3:0], q};
        end
    end
endmodule

module booth_multiplier (
    input wire clk,
    input wire rst,
    input wire start,
    input wire [3:0] multiplier,
    input wire [3:0] multiplicand,
    output wire [7:0] product,
    output wire done
);
    wire load, sub, add, shift;
    wire [1:0] q_dec;

     booth_controller ctrl (
         .clk(clk),
         .rst(rst),
         .start(start),
         .q_dec(q_dec),
          .load(load),
          .sub(sub),
          .add(add),
          .shift(shift),
          .done(done)
     );

     booth_datapath dp (
         .clk(clk),
         .rst(rst),
         .load(load),
         .sub(sub),
         .add(add),
         .shift(shift),
         .multiplier_in(multiplier),
         .multiplicand_in(multiplicand),
         .q_dec(q_dec),
         .product(product)
     );
 endmodule
