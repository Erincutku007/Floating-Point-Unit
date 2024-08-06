`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 06/10/2024 05:03:08 PM
// Design Name: 
// Module Name: ItoF
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


module ItoF(
        input wire is_unsigned,
        input wire [31:0] i,
        output wire is_zero,
        output wire [8:0] sign_and_exp,
        output wire [31:0] mantissa_candidate
    );
    wire i_sign = i[31];
    assign is_zero = i == 32'b0;
    
    wire sign = i_sign & ~is_unsigned;
    wire [7:0]exponent;
    
    wire [31:0]encoder_in,one_dot_mantissa;
    assign encoder_in = (i_sign & ~is_unsigned) ? (~i +32'h1) : i;
    
    wire [4:0]index;
    PriorityEncoder32 enc(
    .data(encoder_in),
    .index(index)
    );
    
    assign one_dot_mantissa = encoder_in << index;
    
    //output assignments
    assign exponent = 8'd158 - {3'b0,index};
    assign mantissa_candidate = {one_dot_mantissa[30:0],1'b0};
    assign sign_and_exp = {sign,exponent};
endmodule
