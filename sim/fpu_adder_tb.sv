`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 03/25/2024 03:26:24 PM
// Design Name: 
// Module Name: fpu_adder_tb
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


module fpu_adder_tb(

    );
    reg [31:0]a,b,op,expected_y;
    reg sub,comp,clk,failed,nearly_eq;
    wire [31:0] y; 
    FloatingPointAddSubComp DUT(	// <stdin>:3:10
    .io_a(a),	// src/main/scala/core/lite/Execute/FPU_ADD.scala:11:14
    .io_b(b),	// src/main/scala/core/lite/Execute/FPU_ADD.scala:11:14
    .io_sub(0),
    .io_comp(1),
    .io_y(y)	// src/main/scala/core/lite/Execute/FPU_ADD.scala:11:14
    );
    
    parameter depth = 1<<15;
    reg [31:0]a_val[depth-1:0];
    reg [31:0]b_val[depth-1:0];
    reg [31:0]y_val[depth-1:0];
    reg [31:0]op_val[depth-1:0];
    
    int i = 0;
    
    always@(*) begin
        a = a_val[i];
        b = b_val[i];
        op = op_val[i];
        expected_y = y_val[i];
    end
    
    initial clk = 0;
        always #10 clk = ~clk;
    
    int rough_success,success,fail,i,fail_ptr;
    
    always@(posedge clk) begin
        failed = y == expected_y;
        nearly_eq = ((y-expected_y)/expected_y) < 0.001; 
        if (y[31:0] == expected_y[31:0]) begin
            success ++;
            rough_success ++;
        end
        else if (nearly_eq)
            rough_success ++;
        else
            fail ++;
        #9;
        i ++;
    end
    
    wire        y_expected_sign = expected_y[31];	// src/main/scala/core/lite/Execute/FPU_ADD.scala:16:36
    wire [7:0]  y_expected_exponent = expected_y[30:23];	// src/main/scala/core/lite/Execute/FPU_ADD.scala:17:36
    wire [22:0] y_expected_mantissa = expected_y[22:0];	// src/main/scala/core/lite/Execute/FPU_ADD.scala:18:36
    
    wire        y_sign = y[31];	// src/main/scala/core/lite/Execute/FPU_ADD.scala:16:36
    wire [7:0]  y_exponent = y[30:23];	// src/main/scala/core/lite/Execute/FPU_ADD.scala:17:36
    wire [22:0] y_mantissa = y[22:0];	// src/main/scala/core/lite/Execute/FPU_ADD.scala:18:36

        
    initial begin
        $readmemh("a.mem", a_val);
        $readmemh("b.mem", b_val);
        $readmemh("y.mem", y_val);
        $readmemh("op.mem", op_val);
        success = 0;
        rough_success = 0;
        fail = 0;
    end
    
endmodule
