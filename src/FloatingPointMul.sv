`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04/09/2024 05:41:34 PM
// Design Name: 
// Module Name: FloatingPointMul
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

//CEME NOT:
module FloatingPointMul(
    input wire [2:0]rounding_mode,
    input wire [31:0]a,b,
    output reg [31:0]y,
    output wire [4:0]FPU_flags
    );
    wire        a_sign = a[31];	// src/main/scala/core/lite/Execute/FPU_ADD.scala:16:36
    wire [7:0]  a_exponent = a[30:23];	// src/main/scala/core/lite/Execute/FPU_ADD.scala:17:36
    wire [22:0] a_mantissa = a[22:0];	// src/main/scala/core/lite/Execute/FPU_ADD.scala:18:36
    
    wire        b_sign = b[31];	// src/main/scala/core/lite/Execute/FPU_ADD.scala:20:36
    wire [7:0]  b_exponent = b[30:23];	// src/main/scala/core/lite/Execute/FPU_ADD.scala:21:36
    wire [22:0] b_mantissa = b[22:0];	// src/main/scala/core/lite/Execute/FPU_ADD.scala:22:36
    
    wire [7:0]b_exponent_minus_bias = b_exponent - 8'd127;
    wire [8:0]exponent_sum_raw = {1'b0,a_exponent} + {1'b0,b_exponent_minus_bias};
    wire [47:0]mantissa_mul = {1'b1,a_mantissa} * {1'b1,b_mantissa};
    
    wire mantissa_MSB = mantissa_mul[47];
    
    wire [47:0]mantissa_shifted = (mantissa_mul >> mantissa_MSB);
    
    wire [8:0]exponent_res = exponent_sum_raw + mantissa_MSB;
    wire [22:0]mantissa_res = mantissa_shifted[46:23];
    wire sign_res = a_sign ^ b_sign;
    
    //rounding
    wire [24:0]rounded_one_dot_mantissa;
    wire [23:0]one_dot_mantissa;
    wire [2:0]GRS;
    reg round_up;
    assign GRS = {mantissa_shifted[22:21], |mantissa_shifted[20:0]};//IEEE 23 biti de sticky bite koy diyor ama yerden kismak icin silinebilir
    always_comb begin
        round_up = 0;
        case(rounding_mode)
            3'b000: round_up = ~((GRS[2] == 1'b0) | ((GRS == 3'b100) & (mantissa_res[0]==1'b0) ) ); //RNE
                                                                                                //RTZ chops the value.
            3'b010: round_up = a_sign & (|GRS);                                                  //RDN if any of the bits are asserted when sgn=1 round mantissa up
            3'b011: round_up = (~a_sign) & (|GRS);                                               //RUP if any of the bits are asserted when sgn=0 round mantissa up
            3'b100: round_up = |GRS;
            default: round_up = ~((GRS[2] == 1'b0) | ((GRS == 3'b100) & (mantissa_res[0]==1'b0) ) );
        endcase
    end
    assign rounded_one_dot_mantissa = {2'b01,mantissa_res} + {24'b0,round_up};
    assign one_dot_mantissa = rounded_one_dot_mantissa >> rounded_one_dot_mantissa[24];
    //flag generation
    wire NV,DZ,OF,UF,NX;
    wire a_is_zero = a == 31'b0;
    wire b_is_zero = b == 31'b0;
    wire a_is_inf = a[30:0] == 31'b1111111100000000000000000000000;
    wire b_is_inf = b[30:0] == 31'b1111111100000000000000000000000;
    assign NV = (a_is_zero & b_is_inf) | (b_is_zero & a_is_inf);
    wire res_is_zero = (a_is_zero | b_is_zero) & ~NV;
    assign DZ = 1'b0;
    assign OF = exponent_res[8] & ~res_is_zero;
    assign UF = 1'b0;
    assign NX = round_up;
    //output assignments
    wire NAN_a = (a[30:23] == (8'b1111_1111)) & ~(a_is_inf);
    wire NAN_b = (a[30:23] == (8'b1111_1111)) & ~(b_is_inf);
    wire NAN = NAN_a | NAN_b;
    wire inf_times_num = ~NV & (a_is_inf | b_is_inf);
    always_comb begin
        y = {sign_res,exponent_res[7:0],one_dot_mantissa[22:0]};
        if (OF | inf_times_num)
            y = {sign_res,31'b1111111100000000000000000000000}; //set to infinity
        else if (NAN) begin
            if (NAN_a)
                y = a; //propagate NAN on the A
            else
                y = b; //propagate NAN on the B
        end
        else if(res_is_zero) // 0*num = 0
            y = 32'b0;
        else if(NV)
            y = 32'h7fc00000; //set to signaling NAN
    end
    assign FPU_flags ={NV,DZ,OF,UF,NX};
endmodule