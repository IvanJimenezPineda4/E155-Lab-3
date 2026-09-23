// E155: Lab 3 - Keypad Scanner
// Ivan Jimenez Pineda, ijimenezpineda@g.hmc.edu
// 9/20/2026
// Testbench for synchronizer.sv

`timescale 1ns/1ps

module synchronizer_testbench();

    logic clk;
    logic reset;
    logic [3:0] async_in;
    logic [3:0] sync_out;

    synchronizer dut (.clk(clk), .reset(reset), .async_in(async_in), .sync_out(sync_out));

    // 24MHz clock
    always begin
        clk = 0; #21;
        clk = 1; #21;
    end

    initial begin
        reset = 0;
        async_in = 4'b1111; // Default pulled HIGH
        #50;
        
        reset = 1; #20;

        // Apply asynchronous inputs off the clock edge
        async_in = 4'b1010; #12; 
        async_in = 4'b0101; #30; 
        
        // Wait to observe the two-clock cycle propagation delay
        #100;
        
        async_in = 4'b1110; #45;
        async_in = 4'b1111; 

        #100;
        $display("Synchronizer tests completed.");
        $stop;
    end
endmodule