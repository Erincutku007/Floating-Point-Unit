`timescale 1ns / 1ps
`default_nettype none
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04/09/2024 05:49:29 PM
// Design Name: 
// Module Name: PriorityEncoder46
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


module PriorityEncoder46(
    input wire [47:0]data,
    output wire [5:0] index
    );
    
    wire [3:0] pe0_o,pe1_o,pe2_o;
    
    priority_encoder_16b pe0(
    .data(data[15:0]),
    .index(pe0_o)
    );
    priority_encoder_16b pe1(
    .data(data[31:16]),
    .index(pe1_o)
    );
    priority_encoder_16b pe2(
    .data(data[47:32]),
    .index(pe2_o)
    );
    wire [2:0]datas_reduced = {|data[47:32], |data[31:16], |data[15:0]};
    wire [2:0]pe3_data = {((pe2_o!=4'b0) | data[47])& datas_reduced[2],((pe1_o!=4'b0) | data[31]) & datas_reduced[1], ((pe0_o!=4'b0) | data[15])& datas_reduced[0]};
    reg [3:0]last_bits;
    reg [1:0]selection;
    
    always_comb begin
        casex(pe3_data)
            3'b1XX: selection = 2'b00; // Second priority input B
            3'b01X: selection = 2'b01; // Third priority input C
            3'b001: selection = 2'b10; // Lowest priority input D
            default: selection = 2'b00;
        endcase
    end
    
    wire [5:0]test;
    
    always_comb begin
        case(selection)
            2'd0: last_bits = pe2_o; // Highest priority input A
            2'd1: last_bits = pe1_o; // Second priority input B
            2'd2: last_bits = pe0_o; // Third priority input C
        endcase
    end
    assign index = {selection,last_bits};
endmodule

module priority_encoder_16b (//only 2bits are wasted and being this wastefull is worth the headache
    input wire [15:0]data,
    output wire [3:0] index
    );
    wire [1:0] pe0_o,pe1_o,pe2_o,pe3_o;
    priority_encoder_4b pe0(
    .data(data[3:0]),
    .index(pe0_o)
    );
    priority_encoder_4b pe1(
    .data(data[7:4]),
    .index(pe1_o)
    );
    priority_encoder_4b pe2(
    .data(data[11:8]),
    .index(pe2_o)
    );
    priority_encoder_4b pe3(
    .data(data[15:12]),
    .index(pe3_o)
    );
    wire [3:0]datas_reduced = {|data[15:12],|data[11:8], |data[7:4], |data[3:0]};
    wire [3:0]pe3_data = {((pe3_o!=2'b0) | data[15])& datas_reduced[3],((pe2_o!=2'b0) | data[11])& datas_reduced[2],((pe1_o!=2'b0) | data[7]) & datas_reduced[1], ((pe0_o!=2'b0) | data[3])& datas_reduced[0]};
    reg [1:0]last_bits;
    reg [1:0]selection;
    
    always_comb begin // this is a priority encdoer that can be instantianised but I wanted to see the logic
        casex(pe3_data)
            4'b1XXX: selection = 2'b00; // 
            4'b01XX: selection = 2'b01; // 
            4'b001X: selection = 2'b10; //
            4'b0001: selection = 2'b11; // 
        endcase
    end
    
    always_comb begin
        case(selection)
            2'd0: last_bits = pe3_o;
            2'd1: last_bits = pe2_o; 
            2'd2: last_bits = pe1_o; 
            2'd3: last_bits = pe0_o;
        endcase
    end
    assign index = {selection,last_bits};
endmodule

module priority_encoder_4b(
        input wire [3:0] data,
        output reg [1:0] index);

always @ (*) begin
    casex(data)
        4'b1XXX: index = 2'b00; // Highest priority input A
        4'b01XX: index = 2'b01; // Second priority input B
        4'b001X: index = 2'b10; // Third priority input C
        4'b0001: index = 2'b11; // Lowest priority input D
        default: index = 00;
    endcase
end

endmodule 