`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04/08/2024 12:15:18 AM
// Design Name: 
// Module Name: Compare
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


module Compare(
        input [31:0]a,b,
        input [8:0]exp_diff,
        input [24:0]mantissa_res,
        output reg a_hi_b,a_equal_b
    );
    wire a_sign = a[31];
    wire b_sign = b[31];
    
    assign exp_c = exp_diff[8];
    assign exp_z = exp_diff[7:0] == 8'b0;
    wire exp_higher = ~exp_z & ~exp_c;
    wire exp_eq = exp_z;
    wire exp_lower = exp_c;
    
    assign man_c = mantissa_res[24];
    assign man_z = mantissa_res[23:0] == 24'b0;
    wire man_higher = ~man_z & ~man_c;
    wire man_eq = man_z;
    wire man_lower = ~man_c;
    
    reg a_is_bigger_than_b;
    wire test = a_sign != b_sign;
    
    always_comb begin
        a_is_bigger_than_b = 0;
        a_equal_b = 0;
        if (a_sign != b_sign) begin
            a_is_bigger_than_b = b_sign;
            a_hi_b = a_is_bigger_than_b;
        end
        else begin
            if (exp_higher) 
                    a_is_bigger_than_b = 1;
            else if (exp_eq) begin
                if (man_eq)
                    a_equal_b = 1;
                else
                    a_is_bigger_than_b = man_higher;
            end
            a_hi_b = a_is_bigger_than_b;
            if (a_sign)
                a_hi_b = ~a_is_bigger_than_b;
        end
    end
endmodule
