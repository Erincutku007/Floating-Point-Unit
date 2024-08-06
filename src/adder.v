module adder (
	input wire [7:0]a,b,
	input wire cin,clk,
	output wire [7:0]sum,
	output wire carry
);

assign {carry,sum} = a+b+cin;

endmodule