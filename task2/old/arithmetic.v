module full_adder(
	input addend1, addend2, carry_in,
	output result, carry_out
);
	assign result = addend1 ^ addend2 ^ carry_in;
	assign carry_out = ( ( addend1^addend2 ) & carry_in )|( addend1 & addend2 );
endmodule


module byte_adder(
	input [7:0] addend1, addend2,
	input carry_in,
	output [7:0] result,
	output carry_out
);
	wire carry0, carry1, carry2, carry3, carry4, carry5, carry6;
	full_adder adder0( .addend1( addend1[0] ), .addend2( addend2[0] ), .carry_in(carry_in), .result( result[0] ), .carry_out( carry0 ) );
	full_adder adder1( .addend1( addend1[1] ), .addend2( addend2[1] ), .carry_in( carry0 ), .result( result[1] ), .carry_out( carry1 ) );
	full_adder adder2( .addend1( addend1[2] ), .addend2( addend2[2] ), .carry_in( carry1 ), .result( result[2] ), .carry_out( carry2 ) );
	full_adder adder3( .addend1( addend1[3] ), .addend2( addend2[3] ), .carry_in( carry2 ), .result( result[3] ), .carry_out( carry3 ) );
	full_adder adder4( .addend1( addend1[4] ), .addend2( addend2[4] ), .carry_in( carry3 ), .result( result[4] ), .carry_out( carry4 ) );
	full_adder adder5( .addend1( addend1[5] ), .addend2( addend2[5] ), .carry_in( carry4 ), .result( result[5] ), .carry_out( carry5 ) );
	full_adder adder6( .addend1( addend1[6] ), .addend2( addend2[6] ), .carry_in( carry5 ), .result( result[6] ), .carry_out( carry6 ) );
	full_adder adder7( .addend1( addend1[7] ), .addend2( addend2[7] ), .carry_in( carry6 ), .result( result[7] ), .carry_out(carry_out) );
endmodule


module subtracter(
	input [7:0] subtrahend, minuhend,
	output [7:0] difference
);
	wire carry_out;
	byte_adder adder( .addend1(subtrahend), .addend2(~minuhend), .result(difference), .carry_in(1'b1), .carry_out(carry_out) );
endmodule

module tb_subtracter;
		reg [7:0]a = 8'd11;
		reg [7:0]b = 8'd12;

		wire [7:0]c;

		subtracter sub( .subtrahend(a), .minuhend(b), .difference(c) );
initial 
	begin
		#10 $display ("%d", c);
	end
endmodule
