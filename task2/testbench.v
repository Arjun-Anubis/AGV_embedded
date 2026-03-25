module testbench();
	reg reset = 0;
	reg clock = 0;
	wire done;
	reg [7:0] angle = 42;


	wire [11:0] x, y;

	CORDIC c( .clock( clock ), .reset( reset ), .angle( angle ), .done( done ), .x( x ), .y( y ) );


	initial begin
		forever begin
			#10 clock = ~clock;
		end
	end

	initial begin
		reset = 1;
		@(posedge clock);
		reset = 0;
		@(posedge done) begin
			$display("Output is x = %d, y = %d", x, y);
		end
		angle = 72;
		reset = 1;
		@(posedge clock);
		reset = 0;
		@(posedge done) begin
			$display("Output is x = %d, y = %d", x, y);
		end

	end
endmodule
