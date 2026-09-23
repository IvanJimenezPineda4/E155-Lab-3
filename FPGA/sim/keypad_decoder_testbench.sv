// E155: Lab 3 - Keypad Scanner
// Ivan Jimenez Pineda, ijimenezpineda@g.hmc.edu
// 9/20/2026
// Testbench for keypad_decoder.sv

`timescale 1ns/1ps

module keypad_decoder_testbench();

    logic [3:0] col;
    logic [3:0] row;
    logic [3:0] key;

    keypad_decoder dut (.col(col), .row(row), .key(key));

    initial begin
        // Initialize inputs
        row = 4'b0000;
        col = 4'b0000;
        #10;

        // row 0 tests
        row = 4'b0001; col = 4'b0001; #10; 
        assert(key == 4'h1) else $error("Failed row 0, col 0: expected 1");

        row = 4'b0001; col = 4'b0010; #10; 
        assert(key == 4'h2) else $error("Failed row 0, col 1: expected 2");

        row = 4'b0001; col = 4'b0100; #10; 
        assert(key == 4'h3) else $error("Failed row 0, col 2: expected 3");

        row = 4'b0001; col = 4'b1000; #10; 
        assert(key == 4'hA) else $error("Failed row 0, col 3: expected A");

        // row 1 tests
        row = 4'b0010; col = 4'b0001; #10; 
        assert(key == 4'h4) else $error("Failed row 1, col 0: expected 4");

        row = 4'b0010; col = 4'b0010; #10; 
        assert(key == 4'h5) else $error("Failed row 1, col 1: expected 5");

        row = 4'b0010; col = 4'b0100; #10; 
        assert(key == 4'h6) else $error("Failed row 1, col 2: expected 6");

        row = 4'b0010; col = 4'b1000; #10; 
        assert(key == 4'hB) else $error("Failed row 1, col 3: expected B");

        // row 2 tests
        row = 4'b0100; col = 4'b0001; #10; 
        assert(key == 4'h7) else $error("Failed row 2, col 0: expected 7");

        row = 4'b0100; col = 4'b0010; #10; 
        assert(key == 4'h8) else $error("Failed row 2, col 1: expected 8");

        row = 4'b0100; col = 4'b0100; #10; 
        assert(key == 4'h9) else $error("Failed row 2, col 2: expected 9");

        row = 4'b0100; col = 4'b1000; #10; 
        assert(key == 4'hC) else $error("Failed row 2, col 3: expected C");

        // row 3 tests
        row = 4'b1000; col = 4'b0001; #10; 
        assert(key == 4'hE) else $error("Failed row 3, col 0: expected E");

        row = 4'b1000; col = 4'b0010; #10; 
        assert(key == 4'h0) else $error("Failed row 3, col 1: expected 0");

        row = 4'b1000; col = 4'b0100; #10; 
        assert(key == 4'hF) else $error("Failed row 3, col 2: expected F");

        row = 4'b1000; col = 4'b1000; #10; 
        assert(key == 4'hD) else $error("Failed row 3, col 3: expected D");

        // Multiple columns pressed
        row = 4'b0001; col = 4'b0011; #10; 
        assert(key == 4'h0) else $error("Failed multiple columns pressed: Expected 0");

        // Multiple rows active
        row = 4'b0011; col = 4'b0001; #10; 
        assert(key == 4'h0) else $error("Failed multiple rows pressed: Expected 0");

        // No keys pressed
        row = 4'b0001; col = 4'b0000; #10; 
        assert(key == 4'h0) else $error("Failed empty press: Expected 0");

        $display("Tests completed");
        $stop;
    end
endmodule