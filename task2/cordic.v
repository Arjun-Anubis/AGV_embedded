`define K8 12'h9B7;

module CORDIC(
	input [7:0] angle,
	input reset, clock,

	output reg [11:0] x, y,
	output reg done
);
	reg [7:0] gamma [7:0];
 
	wire [12:0] Tp_x, Tp_y;
	wire [12:0] Tn_x, Tn_y;
	wire [8:0] angle_p, angle_n;

	reg [12:0] internal_x, internal_y;
	reg [8:0] internal_angle;
	reg [7:0] counter;

	Tp tp( .x( internal_x ), .y( internal_y ), .counter( counter ), .x_out(Tp_x), .y_out(Tp_y) );
	Tn tn( .x( internal_x ), .y( internal_y ), .counter( counter ), .x_out(Tn_x), .y_out(Tn_y) );
	Ap r( .in( internal_angle ), .counter( counter ), .out( angle_p ) );
	An i( .in( internal_angle ), .counter( counter ), .out( angle_n ) );


	initial begin
		counter = 0;
	end

	always @(posedge reset) begin
		internal_angle = angle;
		internal_x = `K8;
		internal_y = 0;
		counter = 0;
	end

	always @(posedge clock) begin
		if ( counter[3] ) begin
			// $display("internally, x and y are %d and %d", internal_x, internal_y);
			x = internal_x[11:0];
			y = internal_y[11:0];
			done = 1;
			@(posedge clock);
			done = 0;
		end
		else begin
			if ( internal_angle[8] ) begin
				internal_angle <= angle_n;
				internal_x <= Tn_x;
				internal_y <= Tn_y;
			end
			else begin
				internal_angle <= angle_p;
				internal_x <= Tp_x;
				internal_y <= Tp_y;
			end
			counter = counter + 1;
		end
	end
	
endmodule

