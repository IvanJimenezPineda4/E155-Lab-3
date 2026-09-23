// E155: Lab 3 - Keypad Scanner
// Ivan Jimenez Pineda, ijimenezpineda@g.hmc.edu
// 9/20/2026
// Testbench for top level lab3_ivan.sv

`timescale 1ns/1ps

module lab3_ivan_testbbench();

    logic reset;
    logic [3:0] col; // Active low
    logic [6:0] seg;
    logic [1:0] anode;
    logic [3:0] row;

    lab3_ivan dut (.reset(reset), .col(col), .seg(seg), .anode(anode), .row(row));

    logic sim_clk = 0;
    always #20.8 sim_clk = ~sim_clk; // 24MHz
    
    initial begin
        force dut.clk = sim_clk;
    end

    initial begin
        reset = 0;
        col = 4'b1111; // Pullups hold unpressed columns high
        #100;
        reset = 1;
        
        // Wait for system to initialize
        #1_000_000; 
    
        // Simulate pressing '5' (Row 1, Col 1)
      
        $display("Simulating bouncy press of button '5'...");
        #13.7;                   // Asynchronous offset from clock edge
        col = 4'b1101; #150_000; // Bounce closed
        col = 4'b1111; #200_000; // Bounce open
        col = 4'b1101; #100_000; // Bounce closed
        col = 4'b1111; #50_000;  // Bounce open
        col = 4'b1101;           // hold
        
        // Wait long enough for the 183Hz FSM (r to p to s to e to w)
        // 5 ticks 
        #30_000_000; 
        
        // Release button
        col = 4'b1111;
        #10_000_000; // Wait for FSM to exit wait state
        
        // Check that '5' made it into the new digit register
        assert(dut.digit_new == 4'h5) else $error("Digit 5 failed to register");

        // Simulate pressing 'A' (Row 0, Col 3)
        $display("Simulating bouncy press of button 'A");
        #13.7;                   // Asynchronous offset
        col = 4'b0111; #150_000; // Bounce closed
        col = 4'b1111; #200_000; // Bounce open
        col = 4'b0111; #100_000; // Bounce closed
        col = 4'b1111; #50_000;  // Bounce open
        col = 4'b0111;           // hold
        
        #30_000_000; 
        
        // Release button
        col = 4'b1111;
        #10_000_000; 
        
        // Check shift register behavior
        assert(dut.digit_new == 4'hA) else $error("Digit A failed to register as new");
        assert(dut.digit_old == 4'h5) else $error("Digit 5 failed to shift to old");

        $display("Top Level System Tests Completed Successfully.");
        $finish;
    end
endmodule