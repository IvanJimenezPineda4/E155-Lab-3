// E155: Lab 3 - Keypad Scanner
// Ivan Jimenez Pineda, ijimenezpineda@g.hmc.edu
// 9/20/2026
// FSM handles row scanning and debouncing

module keypad_fsm (input logic clk,
                   input logic reset,
                   input logic tick,               // 240Hz enable
                   input logic [3:0] col,        
                   output logic [3:0] row,         // active low output to keypad
                   output logic [3:0] active_row,  // active high output to decoder
                   output logic enable);             // Pulse for a valid key press

    typedef enum logic [4:0] {
        r0, r1, r2, r3,  // row scan states
        p0, p1, p2, p3,  // press detect states
        s0, s1, s2, s3,  // sync states
        e0, e1, e2, e3,  // enable states
        w0, w1, w2, w3   // wait for release states
    } state_t;
    
    state_t state, next_state;
    
    // true only if exactly one key is pressed
    logic press;
    always_comb begin
        case (col)
            4'b0001, 4'b0010, 4'b0100, 4'b1000: press = 1'b1;
            default: press = 1'b0;
        endcase
    end

    // first column detected for multiple presses
    logic [3:0] first_col;
    always_ff @(posedge clk) begin
        if (~reset) begin
            first_col <= 4'b0000;
        end else if (tick && (state == s0 || state == s1 || state == s2 || state == s3)) begin
            first_col <= col;
        end
    end
    
    // Check if the original button is still being held down
    logic oneCol;
    assign oneCol = (col & first_col) != 4'b0000;
    
    // Synchronous state transition on tick
    always_ff @(posedge clk) begin
        if (~reset) begin
            state <= r0;
        end else if (tick) begin
            state <= next_state;
        end
    end
    
    // Next-state logic
    always_comb begin
        case(state)
            // Scan Row 0
            r0: if (press) next_state = p0; else next_state = r1;
            p0: next_state = s0;
            s0: next_state = e0;
            e0: next_state = w0;
            w0: if (oneCol) next_state = w0; else next_state = r0;
                
            // Scan Row 1
            r1: if (press) next_state = p1; else next_state = r2;
            p1: next_state = s1;
            s1: next_state = e1;
            e1: next_state = w1;
            w1: if (oneCol) next_state = w1; else next_state = r1;
                
            // Scan Row 2
            r2: if (press) next_state = p2; else next_state = r3;
            p2: next_state = s2;
            s2: next_state = e2;
            e2: next_state = w2;
            w2: if (oneCol) next_state = w2; else next_state = r2;
    
            // Scan Row 3
            r3: if (press) next_state = p3; else next_state = r0;
            p3: next_state = s3;
            s3: next_state = e3;
            e3: next_state = w3;
            w3: if (oneCol) next_state = w3; else next_state = r3;
            
            default: next_state = r0;
        endcase
    end
    
    // FSM Output Logic
    always_comb begin
        row = 4'b1111;
        active_row = 4'b0000;

        if (state == r0 || state == p0 || state == s0 || state == e0 || state == w0) begin
            row = 4'b1110; 
            active_row = 4'b0001;
        end else if (state == r1 || state == p1 || state == s1 || state == e1 || state == w1) begin
            row = 4'b1101; 
            active_row = 4'b0010;
        end else if (state == r2 || state == p2 || state == s2 || state == e2 || state == w2) begin
            row = 4'b1011; 
            active_row = 4'b0100;
        end else if (state == r3 || state == p3 || state == s3 || state == e3 || state == w3) begin
            row = 4'b0111; 
            active_row = 4'b1000;
        end
    end
    
    assign enable = (state == e0) | (state == e1) | (state == e2) | (state == e3); // enable active in these states
    
endmodule
