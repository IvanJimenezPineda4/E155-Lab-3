// E155: Lab 3 - Keypad Scanner
// Ivan Jimenez Pineda, ijimenezpineda@g.hmc.edu
// 9/20/2026
// 2-Flop Synchronizer for 4-bit asynchronous input

module synchronizer (input logic clk,
                     input logic reset,
                     input logic [3:0] async_in,
                     output logic [3:0] sync_out);

    logic [3:0] ff1; //4-bit flip flop

    always_ff @(posedge clk) begin
        if (~reset) begin
            ff1 <= 4'b1111;      // Default to pull-up HIGH
            sync_out <= 4'b1111; 
        end else begin
            ff1 <= async_in;   // asynchronous input and ff1 are evaluated at the same time
            sync_out <= ff1;  // synchronous output gets the old ff1 before it updates with async_in
        end
    end
endmodule