`timescale 1ns/1ps

module testbench();
    reg  reset = 0;
    reg  clock = 0;
    wire done;
    reg  [7:0] angle;
    wire [11:0] x, y;

    CORDIC c( .clock(clock), .reset(reset), .angle(angle), .done(done), .x(x), .y(y) );

    always #5 clock = ~clock;

    initial begin
        $dumpfile("cordic.vcd");
        $dumpvars(0, testbench);
    end

    task run_cordic;
        input [7:0] a;
        begin
            angle = a;
            reset = 1;
            @(posedge clock); #1;
            reset = 0;
            @(posedge done); #1;
            $display("%d, %d, %d", a, x, y);
        end
    endtask

    integer i;
    initial begin
        // single tests
		$display ("angle, x, y");
        run_cordic(0);
        run_cordic(42);
        run_cordic(72);
        run_cordic(90);
        run_cordic(255);

        // sweep
        for (i = 0; i < 256; i = i + 1)
            run_cordic(i);

        $finish;
    end

endmodule
