// E155: Lab 3 - Keypad Scanner
// Ivan Jimenez Pineda, ijimenezpineda@g.hmc.edu
// 9/20/2026
// FSM handles row scanning and debouncing

module keypad_fsm (input logic clk,
                   input logic reset,
                   input logic [3:0] col,       
                   output logic [3:0] row,      
                   output logic [3:0] active_row, 
                   output logic enable);          // pulse for a valid key press

    // 19-bit counter yields ~524,288 cycles at 24MHz ≈ 21.8 ms debounce delay
    parameter DEBOUNCE_TIME = 19'd500_000; 

    typedef enum logic [2:0] {SCAN_STATE, 
                              DEBOUNCE_PRESS_STATE, 
                              TRIGGER_STATE, 
                              HOLD_STATE, 
                              DEBOUNCE_RELEASE_STATE} state_t;
    
    state_t state, next_state;
    
    logic [1:0] scan_row; // current row of the scanner
    logic [18:0] debounce_count;

    always_ff @(posedge clk) begin
        if (~reset) begin
            state <= SCAN_STATE;
            scan_row <= 2'b00;
            debounce_count <= 19'd0;
        end else begin
            state <= next_state;
            case (state)  // FSM logic
                SCAN_STATE: begin
                    debounce_count <= 19'd0;
                    // Rotate the scanned row continuously if no key is pressed
                    if (col == 4'b0000) scan_row <= scan_row + 1'b1; 
                end
                DEBOUNCE_PRESS_STATE, DEBOUNCE_RELEASE_STATE: begin
                    debounce_count <= debounce_count + 1'b1; // Increment debounce timer
                end
                default: debounce_count <= 19'd0;
            endcase
        end
    end

    // FSM next state and output logic
    always_comb begin
        next_state = state;
        enable = 1'b0;

        case (state)
            SCAN_STATE: begin
                if (col != 4'b0000) next_state = DEBOUNCE_PRESS_STATE;
            end
            
            DEBOUNCE_PRESS_STATE: begin
                if (col == 4'b0000) next_state = SCAN_STATE; // bounce
                else if (debounce_count >= DEBOUNCE_TIME) next_state = TRIGGER_STATE;
            end
            
            TRIGGER_STATE: begin
                enable = 1'b1; // Assert single cycle enable
                next_state = HOLD_STATE;
            end
            
            HOLD_STATE: begin
                // Wait until all keys are released to avoid multi-press
                if (col == 4'b0000) next_state = DEBOUNCE_RELEASE_STATE;
            end
            
            DEBOUNCE_RELEASE_STATE: begin
                if (col != 4'b0000) next_state = HOLD_STATE; // Key re-bounced upon release
                else if (debounce_count >= DEBOUNCE_TIME) next_state = SCAN_STATE;
            end
        endcase
    end

    // Output assignments based on current scan index
    always_comb begin
        row = 4'b1111;
        row[scan_row] = 1'b0; // drive the current row low and leave the others floating so that it may be grounded

        active_row = 4'b0000;
        active_row[scan_row] = 1'b1; // is passed onto the keypad_decoder module instead of inverted logic
    end

endmodule
