`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 06/10/2024 03:52:56 PM
// Design Name: 
// Module Name: ConversionUnit
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


module RoundingUnit(
        input wire [1:0]rounding_mode,
        input wire is_zero,
        input wire [8:0] sign_and_exp,
        input wire [31:0] mantissa_candidate,
        output wire [31:0] frounded
    );
    reg round_up;
    wire [2:0]GRS;
    wire [7:0]exponent,exponent_rounded;
    wire [22:0]mantissa_unrounded;
    wire [23:0]one_dot_mantissa;
    wire [24:0]mantissa_rounded;
    assign mantissa_unrounded = mantissa_candidate[31:9];
    
    wire a_sign = sign_and_exp[8];
    assign exponent = sign_and_exp[7:0];
    
    assign GRS = {mantissa_candidate[8:7],|mantissa_candidate[6:0]};
    always_comb begin
        round_up = 0;
        case(rounding_mode)
            3'b000: round_up = ~((GRS[2] == 1'b0) | ((GRS == 3'b100) & (mantissa_unrounded[0]==1'b0) ) ); //RNE
                                                                                                //RTZ chops the value.
            3'b010: round_up = a_sign & (|GRS);                                                  //RDN if any of the bits are asserted when sgn=1 round mantissa up
            3'b011: round_up = (~a_sign) & (|GRS);                                               //RUP if any of the bits are asserted when sgn=0 round mantissa up
            3'b100: round_up = |GRS;
            default: round_up = ~((GRS[2] == 1'b0) | ((GRS == 3'b100) & (mantissa_unrounded[0]==1'b0) ) );
        endcase
    end
    assign mantissa_rounded = {2'b01,mantissa_unrounded} + {24'b0,round_up};
    assign one_dot_mantissa = mantissa_rounded >> mantissa_rounded[24];
    
    assign exponent_rounded = exponent + {7'b0,mantissa_rounded[24]};
    
    assign frounded = {a_sign,exponent_rounded,one_dot_mantissa[22:0]};
endmodule
