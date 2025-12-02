// Name: Angela Luca
// Section: #23200
// File: controller.sv
// Description: Controller for Memory & Datapath of ALU & GCD

module controller #(
    parameter WIDTH = 16,
    parameter INSTR_LEN = 20,
    parameter ADDR = 5
)(
    input  logic clk,
    input  logic reset,
    input  logic go,
    input  logic [INSTR_LEN-1:0] instruction,
    input  logic done,
    output logic enable,
    output logic [ADDR-1:0] pc,
    output logic [3:0] opcode,
    output logic [7:0] a, b,
    output logic invalid_opcode
);

    localparam logic [3:0] HALT_OP = 4'b1111;

    // State Definitions
    typedef enum logic [1:0] { WAIT_GO, FETCH, DECODE, EXECUTE } state_t;
    state_t current_state, next_state;

    // Registered signals
    logic [ADDR-1:0] pc_reg, pc_next;
    logic [3:0]      opcode_reg, opcode_next;
    logic [7:0]      a_reg, b_reg, a_next, b_next;
    logic            enable_next, invalid_next;

    logic [3:0] opcode_now;
    logic       halt_now, valid_now;

    assign opcode_now = instruction[INSTR_LEN-1 -: 4];
    assign halt_now   = (opcode_now == HALT_OP);
    assign valid_now  = (opcode_now == 4'b0001) || // ADD
                        (opcode_now == 4'b0010) || // SUB
                        (opcode_now == 4'b0011) || // MUL
                        (opcode_now == 4'b1011) || // GCD
                        (opcode_now == HALT_OP);   // HALT 

    assign pc             = pc_reg;
    assign opcode         = opcode_reg;
    assign a              = a_reg;
    assign b              = b_reg;
    assign enable         = enable_next;
    assign invalid_opcode = invalid_next;

    // Sequential logic for state and registers
    always_ff @(posedge clk or posedge reset) begin
        if (reset) begin
            current_state <= WAIT_GO;
            pc_reg        <= '0;
            opcode_reg    <= '0;
            a_reg         <= '0;
            b_reg         <= '0;
        end else begin
            current_state <= next_state;
            pc_reg        <= pc_next;
            opcode_reg    <= opcode_next;
            a_reg         <= a_next;
            b_reg         <= b_next;
        end
    end

    // Next state logic and control signals
    always_comb begin
        // Default assignments
        next_state   = current_state;
        pc_next      = pc_reg;
        opcode_next  = opcode_reg;
        a_next       = a_reg;
        b_next       = b_reg;
        enable_next  = 1'b0;
        invalid_next = 1'b0;

        case (current_state)
            WAIT_GO: begin
                if (go)
                    next_state = FETCH;
            end

            FETCH: begin
                // Capture instruction fields into registers
                opcode_next = instruction[INSTR_LEN-1 -: 4];
                a_next      = instruction[15:8];
                b_next      = instruction[7:0];
                next_state  = DECODE;
            end

            DECODE: begin
                if (halt_now) begin
                    // one-cycle output and then stop
                    enable_next = 1'b1;
                    pc_next     = pc_reg + 1'b1;   
                    next_state  = WAIT_GO;         
                end
                else if (valid_now) begin
                    next_state  = EXECUTE;
                end
                else begin
                    // Invalid operation - output zero and return to WAIT_GO
                    invalid_next = 1'b1;
                    enable_next  = 1'b1;
                    pc_next      = pc_reg + 1'b1;  
                    next_state   = WAIT_GO;
                end
            end

            EXECUTE: begin
                // Enable the datapath
                enable_next = 1'b1;
                // Wait for datapath to complete
                if (done) begin
                    pc_next    = pc_reg + 1'b1;   
                    next_state = WAIT_GO;
                end
            end
        endcase
    end

endmodule
