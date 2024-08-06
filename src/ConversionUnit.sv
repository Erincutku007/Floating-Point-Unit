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


module ConversionUnit(
        input wire is_unsigned,
        input wire [1:0]rounding_mode,
        input wire [31:0] i,
        output wire [31:0] f
    );
    wire is_zero;
    wire [8:0] sign_and_exp;
    wire [31:0] mantissa_candidate;
    ItoF itofunit(
        .is_unsigned(is_unsigned),
        .i(i),
        .is_zero(is_zero),
        .sign_and_exp(sign_and_exp),
        .mantissa_candidate(mantissa_candidate)
    );
    
    RoundingUnit round(
        .rounding_mode(rounding_mode),
        .is_zero(is_zero),
        .sign_and_exp(sign_and_exp),
        .mantissa_candidate(mantissa_candidate),
        .frounded(f)
    );
endmodule
