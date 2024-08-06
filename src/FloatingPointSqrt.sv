`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 06/05/2024 10:03:13 PM
// Design Name: 
// Module Name: FloatingPointSqrt
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

module FloatingPointSqrt(
        input wire clk,rst,ready,
        input wire [2:0]rounding_mode,
        input wire [31:0] a,
        output reg [31:0] y,
        output wire [4:0]FPU_flags,
        output wire valid
    );
    //FPU flags
    wire UF;
    //NAN zer0 and infinity handling
    wire pinf= a == 32'h7F800000;
    wire ninf= a == 32'hFF800000;
    wire NAN = (a[30:23] == (8'b1111_1111)) & ~(pinf | ninf); 
    wire zero = a[30:0] == 31'b0;
    wire one = a == 32'h3f800000;
    
    wire e_is_odd;
    reg round_up;
    wire [2:0]GRS;
    wire [27:0] z;
    wire [7:0]  exponent_even,exponent_div_two;
    //input wires
    wire        a_sign = a[31];	
    wire [7:0]  a_exponent = a[30:23];	
    wire [22:0] a_mantissa = a[22:0];	
    wire [23:0] a_dot_mantissa = {1'b1,a_mantissa};
    //output wires
    wire        y_sign;	
    wire [7:0]  y_exponent;	
    wire [22:0] y_mantissa;
    wire [23:0] one_dot_mantissa;
    wire [24:0] rounded_one_dot_sqrt;
    wire [26:0] one_dot_sqrt;
    SquareRoot #(28) sqrt(
        .clk(clk),
        .rst(rst),
        .ready(ready),
        .z(z),
        .one_dot_mantissa_sqrt(one_dot_sqrt),//returns mantissa with 1 extension MSB can be ignored
        .valid(valid)
    );
    //logic
    assign e_is_odd = ~a_exponent[0];
    assign z = {1'b0,a_dot_mantissa,3'b000} << e_is_odd;
    assign exponent_even = e_is_odd ? (a_exponent-8'h01) : a_exponent ;
    assign exponent_div_two = exponent_even >> 1;
    //rounding
    assign GRS = one_dot_sqrt[2:0];
    always_comb begin
        round_up = 0;
        case(rounding_mode)
            3'b000: round_up = ~((GRS[2] == 1'b0) | ((GRS == 3'b100) & (one_dot_sqrt[2]==1'b0) ) ); //RNE
                                                                                                //RTZ chops the value.
            3'b010: round_up = a_sign & (|GRS);                                                  //RDN if any of the bits are asserted when sgn=1 round mantissa up
            3'b011: round_up = (~a_sign) & (|GRS);                                               //RUP if any of the bits are asserted when sgn=0 round mantissa up
            3'b100: round_up = |GRS;
            default: round_up = ~((GRS[2] == 1'b0) | ((GRS == 3'b100) & (one_dot_sqrt[2]==1'b0) ) );
        endcase
    end
    assign rounded_one_dot_sqrt = {1'b0,one_dot_sqrt[26:3]} + {24'b0,round_up};
    assign one_dot_mantissa = rounded_one_dot_sqrt >> rounded_one_dot_sqrt[24];
    //flags
    assign UF = a_exponent == (7'b000_0000) | (7'b000_0001);
    //io assignments
    assign y_sign = a_sign;
    assign y_exponent = exponent_div_two + 8'h40+ {7'b0,rounded_one_dot_sqrt[24]};
    assign y_mantissa = one_dot_mantissa[22:0];
    always_comb begin
        y = {y_sign,y_exponent,y_mantissa};
        if (a_sign)
            y = 32'h7fc00000; //set to signaling NAN
        else if (NAN | pinf | zero | one)
            y = a;
        else if (UF)
            y = 32'h00000000; //incase of an underflow set the result to zero.
    end
//    assign y = {y_sign,y_exponent,y_mantissa};
    
    assign FPU_flags ={a_sign,2'b00,UF,round_up};
endmodule
