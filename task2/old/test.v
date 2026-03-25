module cordic( input clock, input [7:0] angle, input reset, output reg [11:0] sin_out, cos_out, output reg done );
	reg [7:0] counter;
	reg [8:0] full_angle;
	reg [7:0] gamma [0:7];

	reg [12:0] x, y, temp;


	initial begin 
		gamma[0] = 8'd127;
		gamma[1] = 8'd75;
		gamma[2] = 8'd40;
		gamma[3] = 8'd20;
		gamma[4] = 8'd10;
		gamma[5] = 8'd5;
		gamma[6] = 8'd3;
		gamma[7] = 8'd1;

	end
	always @(posedge clock or posedge reset) begin 

		if ( reset ) begin
			$display("Resetting counter & angle"); 
			counter = 0;
			full_angle = angle;
			x = 13'h9B7;
			y = 13'h0;
			$display("Initial: angle = %d, gamma = %d, x = %d, y = %d", full_angle, gamma[counter], x, y );
			$display("Reset"); 
		end

		else begin
			if ( counter[3] ) begin
				done = 1;
				@(posedge clock);
				done = 0;	
			end
			else begin
				temp = y;
				if ( full_angle[8] ) begin
					full_angle = full_angle + gamma[counter];
					y = y - (x>>counter);
					x = x + (temp>>counter);
				end
				else begin
					full_angle = full_angle - gamma[counter];
					y = y + (x>>counter);
					x = x - (temp>>counter);
				end

				$display("%d: angle = %d, gamma = %d, x = %d, y = %d", counter, full_angle, gamma[counter], x, y );

				counter = counter + 1;
				sin_out <= y[11:0];
				cos_out <= x[11:0];
			end

		end

	end
endmodule

module test_bench();
	reg clock;
	reg reset;
	wire done;
	reg [7:0] angle;
	wire [11:0] sin_out, cos_out;
	integer i;
	cordic my_cordic( .clock( clock ), .angle(angle), .sin_out(sin_out), .cos_out(cos_out), .reset(reset), .done(done) );
	initial begin 
		clock = 0;
		repeat(1000) begin
			#10 clock = ~clock;
		end
	end
	initial begin
		for (i = 0; i < 100; i = i + 10) begin
			angle = i;
			reset = 1;
			@(posedge clock);
			reset = 0;	
			@( posedge done )  begin $display ("sin(%d) = %d, cos(%d) = %d", angle, sin_out, angle, cos_out ); end
			@( negedge done );
		end
		
	end
endmodule


