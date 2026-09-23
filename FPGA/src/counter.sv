// // E155: Lab 3 - Keypad Scanner
// Ivan Jimenez Pineda, ijimenezpineda@g.hmc.edu
// 9/20/2026
// counter to output N-bit count

module counter #(parameter width = 24) (
    input logic clk,
    input logic reset,
    input logic enable,
    output logic [width-1:0] count);

    always_ff @(posedge clk) begin
        if (~reset) begin
            count <= 0;
        end
        else if (enable) begin
            count <= count + 1'b1;
        end 
    end
endmodule