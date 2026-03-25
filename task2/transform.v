module Tp(
	input [12:0] x, y,
	input [7:0] counter,
	output [12:0] x_out, y_out
);
	wire cout;
	adder #(.N(13)) a1(
		.cin(1'b0),
		.cout(cout),
		.a(y),
		.b( x >> counter ),
		.sum( y_out)
	);
	adder #(.N(13)) a2(
		.cin(1'b1),
		.cout(cout),
		.a(x),
		.b( ~(y >> counter) ),
		.sum( x_out )
	);
endmodule

module Tn(
	input [12:0] x, y,
	input [7:0] counter,
	output [12:0] x_out, y_out
);
	wire cout;
	adder #(.N(13)) a1(
		.cin(1'b0),
		.cout(cout),
		.a(x),
		.b( y >> counter ),
		.sum( x_out )
	);
	adder #(.N(13)) a2(
		.cin(1'b1),
		.cout(cout),
		.a(y),
		.b( ~(x >> counter) ),
		.sum( y_out )
	);
endmodule

module Ap( input [8:0] in, input [7:0] counter, output [8:0] out );
	wire cout;
	reg [8:0] gamma [8:0];
	initial begin
		gamma[0] = 9'd127;
		gamma[1] = 9'd75;
		gamma[2] = 9'd40;
		gamma[3] = 9'd20;
		gamma[4] = 9'd10;
		gamma[5] = 9'd5;
		gamma[6] = 9'd3;
		gamma[7] = 9'd1;

	end
	adder #(.N(9)) a( .cin(1'b1), .cout(cout), .a(in), .b(~gamma[counter]), .sum(out));
	// assign out = in - gamma[counter];
endmodule

module An( input [8:0] in, input [7:0] counter, output [8:0] out );
	wire cout;
	reg [8:0] gamma [8:0];
	initial begin
		gamma[0] = 9'd127;
		gamma[1] = 9'd75;
		gamma[2] = 9'd40;
		gamma[3] = 9'd20;
		gamma[4] = 9'd10;
		gamma[5] = 9'd5;
		gamma[6] = 9'd3;
		gamma[7] = 9'd1;

	end
	adder #(.N(9)) a( .cin(1'b0), .cout(cout), .a(in), .b(gamma[counter]), .sum(out));
endmodule

