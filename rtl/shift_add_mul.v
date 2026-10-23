 module shift_add_datapath (
     input wire        clk,
     input wire        rst,
     input wire        ld,
     input wire        step,
     input wire [3:0] a_in,
     input wire [3:0] b_in,
     output wire       run_done,
     output wire [7:0] product
 );
     reg [7:0] acc;
     reg [7:0] shifted_a;
     reg [3:0] b_reg;
     reg [2:0] count;

     always @(posedge clk or posedge rst) begin
         if (rst) begin
             acc        <= 8'b0;
             shifted_a <= 8'b0;
             b_reg      <= 4'b0;
             count      <= 3'b0;
         end else if (ld) begin
             acc        <= 8'b0;
             shifted_a <= {4'b0, a_in};
             b_reg     <= b_in;
             count     <= 3'b0;
         end else if (step) begin
             if (b_reg[0])
                 acc <= acc + shifted_a;
             shifted_a <= shifted_a << 1;
             b_reg     <= b_reg >> 1;
             count     <= count + 1'b1;
         end
   end

    assign run_done = (count == 3'd3);
    assign product = acc;
endmodule

module shift_add_controller (
    input wire clk,
    input wire rst,
    input wire start,
    input wire run_done,
    output reg ld,
    output reg step,
    output reg done
);
    parameter S_IDLE = 2'b00;
    parameter S_LOAD = 2'b01;
    parameter S_RUN = 2'b10;
    parameter S_DONE = 2'b11;

   reg [1:0] state, next_state;

   always @(posedge clk or posedge rst) begin
       if (rst) state <= S_IDLE;
       else     state <= next_state;
   end

   always @(*) begin
       ld   = 1'b0;
       step = 1'b0;
       done = 1'b0;
       next_state = state;
       case (state)
           S_IDLE: begin
               if (start) begin
                    ld = 1'b1;
                    next_state = S_LOAD;
               end
           end
           S_LOAD: begin
               next_state = S_RUN;
           end
           S_RUN: begin
               step = 1'b1;
               if (run_done) next_state = S_DONE;
           end
           S_DONE: begin
               done = 1'b1;
               if (!start) next_state = S_IDLE;
           end
             default: next_state = S_IDLE;
         endcase
     end
 endmodule

 module shift_add_mul (
     input wire         clk,
     input wire         rst,
     input wire         start,
     input wire [3:0] a,
     input wire [3:0] b,
     output wire [7:0] product,
     output wire        done
 );
     wire ld, step, run_done;

     shift_add_datapath dp (
         .clk(clk), .rst(rst),
         .ld(ld), .step(step),
         .a_in(a), .b_in(b),
         .run_done(run_done),
         .product(product)
     );

     shift_add_controller ctrl (
         .clk(clk), .rst(rst), .start(start),
         .run_done(run_done),
         .ld(ld), .step(step), .done(done)
     );
 endmodule
