module rotate( input [7:0] angle,
	input reset,
	output reg signed [11:0] sine, cosine
);
	reg signed [15:0] x, y, temp; 
	reg signed [15:0] theta; 

	reg [7:0] gamma [7:0];
	integer i;
 
	initial begin
		gamma[0] = 127;
		gamma[1] = 75;
		gamma[2] = 40;
		gamma[3] = 20;
		gamma[4] = 10;
		gamma[5] = 5;
		gamma[6] = 3;
		gamma[7] = 1;

	end
	always @(*) begin
		x = 16'h09B7;
		y = 0;
		theta = { 8'h00, angle >> 1 };
		for (i=0; i< 8; i = i + 1) begin
			temp  = y;
			if ( theta[15] ) begin
				theta = theta + gamma[i];
				y = y - (x>>>i);
				x = x + (temp>>>i);
			end
			else begin
				theta = theta - gamma[i];
				y = y + (x>>>i);
				x = x - (temp>>>i);
			end
		end
		sine = y[11:0];
		cosine = x[11:0];

	end
endmodule
`timescale 1ns/1ps

module rotate_tb;

    reg  [7:0] angle;
    wire signed [11:0] sine, cosine;

    // Instantiate DUT
    rotate uut (
        .angle(angle),
        .sine(sine),
        .cosine(cosine)
    );

    integer i;

    initial begin
        $display("angle\t sine\t cosine");

        // Sweep through angles
        for (i = 0; i < 256; i = i + 16) begin
            angle = i;
            #10; // wait for combinational logic to settle

            $display("%d\t %d\t %d", angle, sine, cosine);
        end

        $finish;
    end

endmodule
