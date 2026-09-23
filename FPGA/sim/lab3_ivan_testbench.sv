// E155: Lab 3 - Keypad Scanner
// Ivan Jimenez Pineda, ijimenezpineda@g.hmc.edu
// 9/20/2026
// Testbench for top level lab3_ivan.sv

`timescale 1ns/1ps

module lab3_ivan_testbench();

    logic reset;
    logic [3:0] col;
    logic [6:0] seg;
    logic [1:0] anode;
    logic [3:0] row;

    lab3_ivan dut (.reset(reset), .col(col), .seg(seg), .anode(anode), .row(row));

    initial begin
        reset = 0;
        col = 4'b1111; // Columns idle HIGH
        #1000;
        reset = 1;
        
        // Wait for system to stabilize and FSM to begin scanning
        #5000;

        // press key '6' (Row 1, Col 2). 
        // Wait until row[1] goes LOW (active), then pull col[2] LOW
        wait (row == 4'b1101);
        col = 4'b1011; 
        
        $display("Button '6' pressed at %0t", $time);
        
        // Wait 25ms to clear the 500,000 cycle FSM debounce delay
        #25_000_000; 

        // Release the button
        col = 4'b1111;
        $display("Button '6' released at %0t", $time);

        // Wait another 25ms to clear the release debounce delay
        #25_000_000;

        // press key 'A' (Row 0, Col 3).
        wait (row == 4'b1110);
        col = 4'b0111;

        $display("Button 'A' pressed at %0t", $time);

        #25_000_000;
        col = 4'b1111; // Release

        #25_000_000;

        $display("Top level tests completed.");
        $stop;
    end
endmodule