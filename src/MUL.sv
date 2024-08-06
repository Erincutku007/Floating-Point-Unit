`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 02/18/2024 03:49:33 PM
// Design Name: 
// Module Name: MUL
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


module MUL(
    input  wire [31:0]a,
    input  wire [31:0]b,
    input  wire clk,reset,
    output wire [63:0]y
    );
    wire [255:0]decoder_out;
    wire [7:0]decoder_out_arr[31:0];

    wire [63:0]branch0;
    wire [47:0]branch1,branch2;
    wire [31:0]branch3,branch4;
    wire [15:0]branch5,branch6;
    genvar i;
    MUL_DEC decoder(
    .a(a),
    .b(b),
    .y(decoder_out)
    );
    generate
        for (i=0;i<32;i=i+1)begin
            assign decoder_out_arr[i] = decoder_out[8*(i+1)-1:8*i];
        end
    endgenerate

    assign branch0 = {decoder_out_arr[31],decoder_out_arr[23],decoder_out_arr[15],decoder_out_arr[7],decoder_out_arr[5],decoder_out_arr[3],decoder_out_arr[1],8'd0};
    assign branch1 = {decoder_out_arr[29],decoder_out_arr[21],decoder_out_arr[13],decoder_out_arr[6],decoder_out_arr[4],decoder_out_arr[2]};
    assign branch2 = {decoder_out_arr[30],decoder_out_arr[22],decoder_out_arr[14],decoder_out_arr[11],decoder_out_arr[9],decoder_out_arr[8]};
    assign branch3 = {decoder_out_arr[27],decoder_out_arr[19],decoder_out_arr[12],decoder_out_arr[10]};
    assign branch4 = {decoder_out_arr[28],decoder_out_arr[20],decoder_out_arr[17],decoder_out_arr[16]};
    assign branch5 = {decoder_out_arr[25],decoder_out_arr[18]};
    assign branch6 = {decoder_out_arr[26],decoder_out_arr[24]};

    wire [31:0]sum1,sum3;
    wire [63:0]subsum1,subsum2,subsum3,subsum4;
    wire [15:0]sum2;
    wire co1,co2,co3;
    wire [1:0]co4;

    assign {co1,sum1} = branch3 + branch4;
    assign {co2,sum2} = branch5 + branch6;
    assign {co3,sum3} = sum1+{7'd0,co2,sum2,8'd0};
    assign co4 = co3+co1;
    assign subsum1 = {4'd0,2'b00,co4,sum3,16'd0};

    assign subsum2 = branch0 + {8'd0,branch1,8'd0};
    
    assign subsum3 = subsum1 + {8'd0,branch2,8'd0};
    
    assign subsum4 = subsum2+subsum3;

    assign y = {subsum4[63:8],decoder_out_arr[0]};
endmodule