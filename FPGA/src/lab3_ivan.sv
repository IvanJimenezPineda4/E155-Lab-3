// E155: Lab 3 - Keypad Scanner
// Ivan Jimenez Pineda, ijimenezpineda@g.hmc.edu
// 9/20/2026
// Top level module connecting the keypad FSM, decoder, and multiplexed display

module lab3_ivan (input logic reset,
                  input logic [3:0] col,       // keypad column input (active LOW)
                  output logic [6:0] seg,      // multiplexed 7-segment output
                  output logic [1:0] anode,    // anode output for 2-digit display
                  output logic [3:0] row);       // keypad row output (active LOW)

    // 48MHz divided by 2 = 24MHz clock
    logic clk; 
    HSOSC #(.CLKHF_DIV("0b01")) hf_osc(.CLKHFPU(1'b1), .CLKHFEN(1'b1), .CLKHF(clk));

    // Synchronize asynchronous column inputs to system clock
    logic [3:0] col_sync;
    synchronizer sync_cols (.clk(clk), .reset(reset), .async_in(col), .sync_out(col_sync));

    // Invert synchronized columns so a press is considered active-HIGH
    logic [3:0] col_active_high;
    assign col_active_high = ~col_sync;

    // FSM signals
    logic [3:0] active_row;
    logic enable;

    // FSM with debouncing
    keypad_fsm fsm (.clk(clk), .reset(reset), .col(col_active_high), .row(row), .active_row(active_row), .enable(enable));

    // Keypad Decoder
    logic [3:0] decoded_key;
    keypad_decoder decoder (.col(col_active_high), .row(active_row), .key(decoded_key));

    // Shift Register for Display (store last two presses)
    logic [3:0] digit_new, digit_old;
    always_ff @(posedge clk) begin
        if (~reset) begin
            digit_new <= 4'h0;
            digit_old <= 4'h0;
        end else if (enable) begin
            digit_old <= digit_new; // Shift older digit to the left
            digit_new <= decoded_key; // Newest digit on the right
        end
    end

    // Display Multiplexing Logic
    logic [16:0] mux_count; 
    counter #(.width(17)) mux_cntr (.clk(clk), .reset(reset), .enable(1'b1), .count(mux_count));

    logic mux_out;
    assign mux_out = mux_count[16];

    // Select older digit for left display (mux_out=0), new for right (mux_out=1)
    logic [3:0] current_hex;
    assign current_hex = mux_out ? digit_old : digit_new; 
    
    assign anode[0] = mux_out; 
    assign anode[1] = ~mux_out;

    seven_segment segments (.s(current_hex), .seg(seg));

endmodule