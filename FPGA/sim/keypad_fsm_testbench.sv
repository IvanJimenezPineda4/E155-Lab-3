// E155: Lab 3 - Keypad Scanner
// Ivan Jimenez Pineda, ijimenezpineda@g.hmc.edu
// 9/20/2026
// Testbench for keypad_fsm.sv

`timescale 1ns/1ps

module keypad_fsm_testbench();

    logic clk, reset, tick;
    logic [3:0] col;
    logic [3:0] row, active_row;
    logic enable;

    keypad_fsm dut (
        .clk(clk),
        .reset(reset),
        .tick(tick),
        .col(col),
        .row(row),
        .active_row(active_row),
        .enable(enable)
    );

    always #5 clk = ~clk;

    initial begin
        $display("Starting Keypad FSM Tests...");
        clk = 0; reset = 0; tick = 0; col = 4'b0000;
        #20; reset = 1;
        
        // Test 1: Idle Scanning Behavior
        assert(active_row == 4'b0001) else $error("Failed initial state r0");
        
        @(posedge clk); tick = 1; @(posedge clk); tick = 0; // r0 -> r1
        #1; assert(active_row == 4'b0010) else $error("Failed state r1");
        
        @(posedge clk); tick = 1; @(posedge clk); tick = 0; // r1 -> r2
        #1; assert(active_row == 4'b0100) else $error("Failed state r2");
        
        // Test 2: Valid Key Press on Row 2 (active_row = 0100)
        col = 4'b0010; // active HIGH press
        
        @(posedge clk); tick = 1; @(posedge clk); tick = 0; // r2 -> p2
        @(posedge clk); tick = 1; @(posedge clk); tick = 0; // p2 -> s2
        @(posedge clk); tick = 1; @(posedge clk); tick = 0; // s2 -> e2
        
        #1; assert(enable == 1) else $error("Enable failed to assert");
        
        @(posedge clk); tick = 1; @(posedge clk); tick = 0; // e2 -> w2
        #1; assert(enable == 0) else $error("Enable failed to deassert");
        
        // Test 3: Multi-press lockout while holding
        col = 4'b0110; // User accidentally mashes a second button
        
        @(posedge clk); tick = 1; @(posedge clk); tick = 0;
        @(posedge clk); tick = 1; @(posedge clk); tick = 0;
        #1; assert(dut.state == 5'd18) else $error("Failed to hold wait state w2 during multi-press"); // 18 is enum w2
        
        // Test 4: Release key
        col = 4'b0000; 
        
        @(posedge clk); tick = 1; @(posedge clk); tick = 0; // w2 -> r2
        @(posedge clk); tick = 1; @(posedge clk); tick = 0; // r2 -> r3
        #1; assert(active_row == 4'b1000) else $error("Failed to resume scanning at r3");

        $display("Keypad FSM Tests Completed.");
        $finish;
    end
endmodule