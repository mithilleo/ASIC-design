 module gcd_datapath (
     input wire        clk,
     input wire        rst,
     input wire        ld_xy,
     input wire        sub_x,
     input wire        sub_y,
     input wire        done,      // also used as the gcd capture enable
     input wire [7:0] u_in,
     input wire [7:0] v_in,
     output wire       gt,
     output wire       lt,
     output wire       eq,
     output reg [7:0] gcd
 );
     reg [7:0] X, Y;

     always @(posedge clk or posedge rst) begin
         if (rst) begin
             X <= 8'b0;
             Y <= 8'b0;
         end else if (ld_xy) begin
             X <= u_in;
             Y <= v_in;
         end else if (sub_x) begin
              X <= X - Y;
          end else if (sub_y) begin
              Y <= Y - X;
          end
    end

    // gcd is a held output register: it only updates on the cycle the
    // controller asserts done (X==Y at that point), and holds its value
    // otherwise -- matching the synthesized SDFF (SI = X, SE = done).
    always @(posedge clk or posedge rst) begin
        if (rst)       gcd <= 8'b0;
        else if (done) gcd <= X;
    end

    assign gt = (X > Y);
    assign lt = (X < Y);
    assign eq = (X == Y);
endmodule

module gcd_controller (
    input wire clk,
    input wire rst,
    input wire start,
    input wire gt,
    input wire lt,
    input wire eq,
    output reg ld_xy,
    output reg sub_x,
    output reg sub_y,
    output reg done
);
    parameter S_IDLE    = 3'b000;
    parameter S_LOAD    = 3'b001;
    parameter S_COMPARE = 3'b010;
    parameter S_SUB_X   = 3'b011;
    parameter S_SUB_Y   = 3'b100;
    parameter S_DONE    = 3'b101;

    reg [2:0] state, next_state;

    always @(posedge clk or posedge rst) begin
        if (rst) state <= S_IDLE;
        else     state <= next_state;
    end

    always @(*) begin
        ld_xy = 1'b0;
        sub_x = 1'b0;
        sub_y = 1'b0;
        done    = 1'b0;
        next_state = state;
        case (state)
            S_IDLE: begin
                 if (start) begin
                     ld_xy = 1'b1;
                     next_state = S_LOAD;
                 end
            end
            S_LOAD: begin
                 next_state = S_COMPARE;
             end
             S_COMPARE: begin
                 if (eq)      next_state = S_DONE;
                 else if (gt) next_state = S_SUB_X;
                 else         next_state = S_SUB_Y;
             end
             S_SUB_X: begin
                 sub_x = 1'b1;
                 next_state = S_COMPARE;
             end
             S_SUB_Y: begin
                 sub_y = 1'b1;
                 next_state = S_COMPARE;
             end
             S_DONE: begin
                 done = 1'b1;
                 if (!start) next_state = S_IDLE;
             end
             default: next_state = S_IDLE;
         endcase
     end
 endmodule

 module gcd_accelerator (
     input wire        clk,
     input wire        rst,
     input wire        start,
     input wire [7:0] u,
     input wire [7:0] v,
     output wire [7:0] gcd,
     output wire       done
 );
     wire ld_xy, sub_x, sub_y, gt, lt, eq;

     gcd_datapath dp (
         .clk(clk), .rst(rst),
         .ld_xy(ld_xy), .sub_x(sub_x), .sub_y(sub_y), .done(done),
         .u_in(u), .v_in(v),
         .gt(gt), .lt(lt), .eq(eq),
         .gcd(gcd)
     );

     gcd_controller ctrl (
         .clk(clk), .rst(rst), .start(start),
         .gt(gt), .lt(lt), .eq(eq),
         .ld_xy(ld_xy), .sub_x(sub_x), .sub_y(sub_y),
         .done(done)
     );
 endmodule
