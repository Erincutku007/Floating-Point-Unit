`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04/06/2024 06:29:32 PM
// Design Name: 
// Module Name: FloatingPointAddSubComp
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////

module FloatingPointAddSubComp(
    input         clock,	// <stdin>:4:11
                  reset,	// <stdin>:5:11
    input  [31:0] io_a,	// src/main/scala/core/lite/Execute/FPU_ADD.scala:11:14
                  io_b,	// src/main/scala/core/lite/Execute/FPU_ADD.scala:11:14
    input         io_sub,
                  io_comp,
    output [31:0] io_y,	// src/main/scala/core/lite/Execute/FPU_ADD.scala:11:14
    output        io_a_hi_b,
                  io_a_equal_b
    );
    
    wire [31:0]a,b,y;
    reg [2:0]controls;
    wire [31:0]res;
    wire op,res_sign,shuffle_a_b;
    wire [1:0]signs;
    wire [8:0]exp_diff;
    wire [24:0]mantissa_res;
    
    assign signs = {io_a[31],io_b[31]};
    assign {op,res_sign,shuffle_a_b} = controls;
    assign a = shuffle_a_b ? io_b: io_a;
    assign b = shuffle_a_b ? io_a: io_b;
    assign y = {res_sign,res[30:0]};
    
    floatingPointAdder add_sub(	// <stdin>:3:10
      .clock(clock),	// <stdin>:4:11
      .reset(reset),	// <stdin>:5:11
      .io_a({1'b0,a[31:0]}),	// src/main/scala/core/lite/Execute/FPU_ADD.scala:11:14
      .io_b({1'b0,b[31:0]}),	// src/main/scala/core/lite/Execute/FPU_ADD.scala:11:14
      .io_op(op),
      .rounding_mode(0),
      .io_y(res),	// src/main/scala/core/lite/Execute/FPU_ADD.scala:11:14
      .io_exponent_diff(exp_diff),
      .io_mantissa_res(mantissa_res)
    );
    
    Compare comp(
        .a(io_a),
        .b(io_b),
        .exp_diff(exp_diff),
        .mantissa_res(mantissa_res),
        .a_hi_b(io_a_hi_b),
        .a_equal_b(io_a_equal_b)
    );
    
    always @(*) begin
        if (io_comp)
            controls = 3'b1X0;
        else begin
            if (io_sub) begin
                case(signs)
                2'b00:   controls = {1'b1,res[31],1'b0};
                2'b01:   controls = 3'b000;
                2'b10:   controls = 3'b010;
                2'b11:   controls = {1'b1,res[31],1'b1};
                endcase
            end
            else begin
                case(signs)
                2'b00:   controls = 3'b000;
                2'b01:   controls = {1'b1,res[31],1'b0};
                2'b10:   controls = {1'b1,res[31],1'b1};
                2'b11:   controls = 3'b010;
                endcase
            end
       end
    end
    //NAN and inf propagation
    reg [31:0]y_reg;
    wire a_pinf = io_a == 32'h7F800000;
    wire b_pinf = io_b == 32'h7F800000;
    wire pinf = a_pinf | b_pinf;
    
    wire a_ninf = io_a == 32'hFF800000;
    wire b_ninf = io_b == 32'hFF800000;
    wire ninf = a_ninf | b_ninf;
    
    wire inf = pinf | ninf;
    
    wire a_NAN = (io_a[30:23] == (8'b1111_1111)) & ~(a_pinf | a_pinf);
    wire b_NAN = (io_a[30:23] == (8'b1111_1111)) & ~(b_pinf | b_pinf);
    wire NAN = a_NAN | b_NAN; 
    always_comb begin
        if (NAN)
            y_reg = 32'h7fc00000; //when one number is nan, propagate nan
        else if (inf) begin
            if (pinf)
                y_reg = 32'h7F800000; //propagate pinf
            else
                y_reg = 32'hFF800000; //propagate ninf
        end
        else
            y_reg = y;
    end
    assign io_y = y_reg;
endmodule
