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


module fpu_mul_tb(

    );
    reg clk,failed;
    reg [31:0]a,b,expected_y;
    wire [31:0]y;
    
    parameter depth = 1<<8;
    reg [31:0]a_val[depth-1:0];
    reg [31:0]b_val[depth-1:0];
    reg [31:0]y_val[depth-1:0];
    
    wire        expected_sign = expected_y[31];	// src/main/scala/core/lite/Execute/FPU_ADD.scala:16:36
    wire [7:0]  expected_exponent = expected_y[30:23];	// src/main/scala/core/lite/Execute/FPU_ADD.scala:17:36
    wire [22:0] expected_mantissa = expected_y[22:0];	// src/main/scala/core/lite/Execute/FPU_ADD.scala:18:36
    
    int i = 0;
    
    always@(*) begin
        a = a_val[i];
        b = b_val[i];
        expected_y = y_val[i];
    end
    
    initial clk = 0;
        always #10 clk = ~clk;
    
    int success,fail,i,fail_ptr;
    
    always@(posedge clk) begin
        failed = y == expected_y;
        if (y == expected_y)
            success ++;
        else
            fail ++;
        #9;
        i ++;
    end
    
    FloatingPointMul DUT(	// <stdin>:3:10
    .a(a),	// src/main/scala/core/lite/Execute/FPU_ADD.scala:11:14
    .b(b),	// src/main/scala/core/lite/Execute/FPU_ADD.scala:11:14
    .y(y)	// src/main/scala/core/lite/Execute/FPU_ADD.scala:11:14
    );
    initial begin
        $readmemh("a.mem", a_val);
        $readmemh("b.mem", b_val);
        $readmemh("y.mem", y_val);
        success = 0;
        fail = 0;
    end
endmodule
