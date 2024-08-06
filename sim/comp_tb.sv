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


module comp_tb(

    );
    reg [31:0]a,b,op;
    reg sub,comp,clk,failed;
    reg [1:0]expected_y;
    wire io_a_hi_b,io_a_equal_b;
    FloatingPointAddSubComp DUT(	// <stdin>:3:10
    .io_a(a),	// src/main/scala/core/lite/Execute/FPU_ADD.scala:11:14
    .io_b(b),	// src/main/scala/core/lite/Execute/FPU_ADD.scala:11:14
    .io_sub(0),
    .io_comp(1),
    .io_y(),	// src/main/scala/core/lite/Execute/FPU_ADD.scala:11:14
    .io_a_hi_b(io_a_hi_b),
    .io_a_equal_b(io_a_equal_b)
    );
    
    parameter depth = 1<<15;
    reg [31:0]a_val[depth-1:0];
    reg [31:0]b_val[depth-1:0];
    reg [1:0]y_val[depth-1:0];
    reg [31:0]op_val[depth-1:0];
    
    wire [1:0] y = {io_a_equal_b, (~io_a_equal_b & io_a_hi_b) };
    
    int i = 0;
    
    always@(*) begin
        a = a_val[i];
        b = b_val[i];
        op = op_val[i];
        expected_y = y_val[i];
    end
    
    initial clk = 0;
        always #10 clk = ~clk;
    
    int success,fail,fail_ptr;
    
    always@(posedge clk) begin
        failed = ~(y == expected_y);
        if (y == expected_y)
            success ++;
        else
            fail ++;
        #9;
        i ++;
    end

        
    initial begin
        $readmemh("a.mem", a_val);
        $readmemh("b.mem", b_val);
        $readmemh("y.mem", y_val);
        $readmemh("op.mem", op_val);
        success = 0;
        fail = 0;
    end
    
endmodule
