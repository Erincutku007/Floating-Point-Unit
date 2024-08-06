`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 06/04/2024 12:22:37 AM
// Design Name: 
// Module Name: sqrt_tb
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


module sqrt_tb(

    );
    parameter depth = 1<<14;
    reg clk,rst,shift_en,parallel_en,ready,valid;
    reg [31:0]num[depth-1:0];
    reg [31:0]num_sqrt[depth-1:0];
    reg [31:0]fails[127:0];
    wire [31:0]y,expected_val;
    reg [31:0]a;
    
    FloatingPointSqrt DUT(
    .clk(clk),
    .rst(rst),
    .ready(ready),
    .rounding_mode(3'b000),
    .a(a),
    .y(y),//returns mantissa with 1 extension MSB can be ignored
    .valid(valid)
    );
    
     SquareRoot #(25) UUT(
        .clk(clk),
        .rst(rst),
        .ready(ready),
        .z(25'b0110000000000000000000000),
        .one_dot_mantissa_sqrt(),//returns mantissa with 1 extension MSB can be ignored
        .valid()
    );
    
    int success,fail,i,fail_ptr;
    
    initial clk = 0;
        always #10 clk = ~clk;
    
    assign expected_val = num_sqrt[i];
    
    initial begin
        success = 0;
        fail = 0;
        i = 0;
        fail_ptr = 0;
        $readmemh("values.mem", num);
        $readmemh("sqrtvalues.mem", num_sqrt);
        ready = 1;
        rst = 0;
        a = num[i];
        #30;
        rst = 1;
        #100;
    end
    always@(posedge valid) begin
        if (y[31:0] == expected_val[31:0])
            success ++;
        else begin
            fail ++;
            fails[fail_ptr] = a;
            fail_ptr ++;
        end
        #5;
        i++;
        a = num[i];
    end
endmodule
