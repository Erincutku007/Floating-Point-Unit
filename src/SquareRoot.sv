`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04/23/2024 04:53:27 PM
// Design Name: 
// Module Name: SquareRoot
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


module SquareRoot #(SIZE = 8)(
    input wire clk,rst,ready,
    input  wire [SIZE-1:0]z,
    output wire [SIZE-2:0]one_dot_mantissa_sqrt,//returns mantissa with 1 extension MSB can be ignored
    output wire valid
    );
    wire rst_clk,is_neg;
    wire [SIZE-2:0]q,q_next,q_positive_mask,next_bit_mask;
    wire [$clog2(SIZE)-1:0]count;
    wire [SIZE:0]s_i,s_i_reg,s_i_minus_one_next,s_i_plus_one,s_i_minus_one,restored_val,restored_val_raw,q_extended,positive_q_mask,sub_val;
    wire [SIZE:0]z_minus_one;
    
    reg state,next_state;
    wire init;
   //module defs
   counter #($clog2(SIZE)) cnt (
        .clk(clk),
        .rst(rst),
        .sync_rst(rst_clk),
        .en(init | state),
        .counter(count)
   );
   assign rst_clk = (count == SIZE-2);
   
   D_FlipFlop #(SIZE+1) si_reg (
        .clk(clk),
        .reset(rst),
        .d(s_i_plus_one),
        .q(s_i_reg)
    );
    
    assign s_i_minus_one_next = (count == 0) ? z_minus_one : restored_val_raw;
    FFSyncAsyncRst #(SIZE+1) s_i_minus_one_reg (
        .clk(clk),
        .reset(rst),
        .rst_sync(rst_clk),
        .d(s_i_minus_one_next),
        .q(s_i_minus_one)
    );
    
    FFSyncAsyncRst #(SIZE-1) q_reg (
        .clk(clk),
        .reset(rst),
        .rst_sync(rst_clk),
        .d(q_next),
        .q(q)
    );
    
    ShiftReg #(SIZE-1) mask_reg(
        .clk(clk),
        .reset(rst),
        .rst_sync(rst_clk),
        .shift_en(1'b1),
        .parallel_en(1'b0),
        .parallel_input(1'b0),
        .d(),
        .q(next_bit_mask)
    );
    
    //logic 
    assign z_minus_one = z - ( 1<<(SIZE-2));
    assign s_i = (count == 0) ? z_minus_one : s_i_reg;
    assign is_neg = s_i[SIZE];
    assign restored_val_raw = is_neg ? (s_i_minus_one<<1) : s_i ;
    assign restored_val = restored_val_raw <<1;
    assign q_positive_mask = next_bit_mask & ~{(SIZE-1){is_neg}};
    assign q_next = q_positive_mask | q;
    assign q_extended = {1'b0,q_next,1'b0};
    assign positive_q_mask = {2'b00,(next_bit_mask>>1)};
    assign sub_val = q_extended | positive_q_mask;
    assign s_i_plus_one = restored_val - sub_val;
    //AXI FSM
    assign init = ready & (count == 0);
    always_ff@(posedge clk or negedge rst) begin
        if (~rst)
            state <= 0;
        else
            state <= next_state;
    end
    
    always_comb begin
        case (state)
            1'b0: next_state = init;
            1'b1: next_state = ~rst_clk;
        endcase
    end
    //io assignment
    
    assign one_dot_mantissa_sqrt = q_next;
    assign valid = rst_clk;
endmodule