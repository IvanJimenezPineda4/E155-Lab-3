// E155: Lab 3 - Keypad Scanner
// Ivan Jimenez Pineda, ijimenezpineda@g.hmc.edu
// 9/20/2026
// Testbench for synchronizer.sv
`timescale 1ns/1ps

module synchronizer_testbench();

    logic clk, reset;
    logic [3:0] async_in;
    logic [3:0] sync_out;

    synchronizer dut (.clk(clk), .reset(reset), .async_in(async_in), .sync_out(sync_out));

    // 24MHz Clock Generation
    always #20.8 clk = ~clk;

    initial begin
        $display("Starting Synchronizer");
        clk = 0;
        reset = 0;
        async_in = 4'b1111;
        
        #100;
        reset = 1;
        
        // Assert async input exactly on clock edge
        @(posedge clk);
        async_in = 4'b1110; 
        
        // Verify takes exactly 2 clock cycles to propagate
        @(posedge clk); #1; assert(sync_out == 4'b1111) else $error("Failed Flop 1 isolation");
        @(posedge clk); #1; assert(sync_out == 4'b1110) else $error("Failed Flop 2 sync");
        
        // Assert async input arriving asynchronously between clocks
        #13.5; 
        async_in = 4'b1101;
        
        @(posedge clk);
        @(posedge clk); #1; assert(sync_out == 4'b1101) else $error("Failed Async timing offset");

        $display("Synchronizer Tests Completed.");
        $finish;
    end
endmodule