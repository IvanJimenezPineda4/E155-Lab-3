// E155: Lab 3 - Keypad Scanner
// Ivan Jimenez Pineda, ijimenezpineda@g.hmc.edu
// 9/20/2026
// Combinational logic decoding keypad to hex values

module keypad_decoder (input logic [3:0] col,
                       input logic [3:0] row,
                       output logic [3:0] key);

    always_comb begin
        case ({row, col})
            {4'b0001, 4'b0001}: key = 4'h1;
            {4'b0001, 4'b0010}: key = 4'h2;
            {4'b0001, 4'b0100}: key = 4'h3;
            {4'b0001, 4'b1000}: key = 4'hA;
            
            {4'b0010, 4'b0001}: key = 4'h4;
            {4'b0010, 4'b0010}: key = 4'h5;
            {4'b0010, 4'b0100}: key = 4'h6;
            {4'b0010, 4'b1000}: key = 4'hB;
            
            {4'b0100, 4'b0001}: key = 4'h7;
            {4'b0100, 4'b0010}: key = 4'h8;
            {4'b0100, 4'b0100}: key = 4'h9;
            {4'b0100, 4'b1000}: key = 4'hC;
            
            {4'b1000, 4'b0001}: key = 4'hE;
            {4'b1000, 4'b0010}: key = 4'h0;
            {4'b1000, 4'b0100}: key = 4'hF;
            {4'b1000, 4'b1000}: key = 4'hD;
            
            default: key = 4'h0;
        endcase
    end
endmodule