`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 06/17/2024 12:58:56 AM
// Design Name: 
// Module Name: FtoI
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


module FtoI(
    input wire [31:0]f,
    input wire is_unsigned,
    output wire [31:0]i
    );
    reg [31:0] reg_i;
    
    wire f_sign = f[31];
    wire [7:0]f_exponent = f[30:23];
    wire [22:0]f_mantissa = f[22:0];
    
    wire [7:0]exponent_denormalised = f_exponent - 8'd127;
    wire exponent_neg = exponent_denormalised[7];
    
    wire [23:0]one_dot_mantissa = {1'b1,f_mantissa};
    wire [54:0]extended_value_raw = {31'b0,one_dot_mantissa};
    wire [54:0]extended_value_shifted = extended_value_raw << exponent_denormalised[4:0];
    
    wire [31:0]integer_val = extended_value_shifted[54:23];
    wire [31:0]integer_complement = ~integer_val + 32'd1;
    wire [31:0]integer_val_signed_unsigned = f_sign ? 32'b0 : integer_val;
    wire [31:0]integer_val_signed = f_sign ? integer_complement : integer_val;
    //misc values for later handling
    wire pinf = f == 32'h7F800000;
    wire ninf = f == 32'hFF800000;
    wire NAN = (f[30:23] == (8'b1111_1111)) & ~(pinf | ninf); 
    //hazard handing for signed mode
    wire positive_of = (~f_sign & (exponent_denormalised > 8'd30) )| pinf | NAN;
    wire negative_of = (f_sign & (exponent_denormalised > 8'd30)  )| ninf;
    //hazard handling for unsigned mode
    wire unsigned_of =  (exponent_denormalised > 8'd31) | pinf | NAN;
    
    always_comb begin
        if (is_unsigned) begin
            if (unsigned_of)
                reg_i = 32'hff_ff_ff_ff; //if the val overflows the result is biggest representable uint
            else
                reg_i = integer_val_signed_unsigned;
        end
        else begin
            if (positive_of)
                reg_i = 32'h7fffffff; //if the val overflows the result is biggest representable int
            else if (negative_of)
                reg_i = 32'h80000000; //if the val overflows the result is biggest representable int
            else
                reg_i = integer_val_signed;
        end
    end
    
    assign i = reg_i;
endmodule
