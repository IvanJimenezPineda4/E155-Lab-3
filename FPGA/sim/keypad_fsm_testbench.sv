// E155: Lab 3 - Keypad Scanner
// Ivan Jimenez Pineda, ijimenezpineda@g.hmc.edu
// 9/20/2026
// Testbench for keypad_fsm.sv

`timescale 1ns/1ps

module keypad_fsm_testbench();

    logic clk;
    logic reset;
    logic [3:0] col;
    logic [3:0] row;
    logic [3:0] active_row;
    logic enable;

    // Instantiate FSM with a debounce time
    keypad_fsm #(.DEBOUNCE_TIME(5)) dut (.clk(clk), .reset(reset), .col(col), .row(row), .active_row(active_row), .enable(enable));

    always begin
        clk = 0; #21;
        clk = 1; #21;
    end

    initial begin
        reset = 0; col = 4'b0000; #50;
        reset = 1; #50;

        // switch bounce
        col = 4'b0010; #80; // Hold
        col = 4'b0000; #100;
        assert(enable == 0) else $error("Enable triggered on bounce");

        // solid press
        col = 4'b0010; 
        #300; // Hold
        
        // Wait to observe the enable pulse
        #100;

        // release with bounce
        col = 4'b0000; #50; 
        col = 4'b0010; #100; 
        col = 4'b0000; #300; // Full release, passes release debounce

        $display("FSM tests completed.");
        $stop;
    end
endmodule