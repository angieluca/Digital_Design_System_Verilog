// Name: Angela Luca
// Section: #23200
// File: controller.sv
// Description: Controller for Memeory & Datapath of ALU & GCD

module controller #(parameter WIDTH = 16,
                    parameter INSTR_LEN = 20,
                    parameter ADDR = 5) 
    (
    input  logic        clk,
    input  logic        reset,
    input logic         go,
    input  logic [INSTR_LEN-1:0] instruction,
    input  logic        done,
    output logic        enable,
    output logic [ADDR-1:0]  pc,
    output logic [3:0]  opcode,
    output logic [7:0]  a, b,
    output logic invalid_opcode
);

// 4 dif states so 2 bits
typedef enum logic[1:0] {
    WAIT,       // Wait for go signal to go true
    FETCH,      // Enable read to get data from memory
    EXTRACT,    // Decode instruction into opcode, a, and b
    EXECUTE     // Enable datapath to do insruction and check if invalid opcode
} states; 

states current_state, next_state;
logic [ADDR-1:0] pc_reg, pc_next;

// Sequential logic for state and PC
always_ff @(posedge clk or posedge reset) begin
    if (reset) begin
        current_state <= WAIT;
        pc_reg <= '0;
    end else begin
        current_state <= next_state;
        pc_reg <= pc_next;
    end
end

// Next state logic and control signals
always_comb begin
    // Default assignments
    next_state = current_state;
    pc_next = pc_reg;
    enable = 1'b0;
    invalid_opcode = 1'b0;

    case(current_state) 
        WAIT: begin
            if (go) begin
                next_state = FETCH;
            end else begin
                next_state = WAIT;
            end
        end

        FETCH: begin
            next_state = DECODE; // Fetching instruction takes 1 cycle
        end

        DECODE: begin
            // Check if HALT opcode
            if (instruction[INSTR_LEN-1:INSTR_LEN - 4] == 4'b1011) begin
                next_state = WAIT;
            end else begin
                next_state = EXECUTE;
            end
        end

        EXECUTE: begin
            // Enable datapath
            enable = 1'b1;

            // Check if invalid opcode
            if (instruction[INSTR_LEN-1:INSTR_LEN - 4] != 4'b0001 &&
                instruction[INSTR_LEN-1:INSTR_LEN - 4] != 4'b0010 &&
                instruction[INSTR_LEN-1:INSTR_LEN - 4] != 4'b0011 &&
                instruction[INSTR_LEN-1:INSTR_LEN - 4] == 4'b1011) begin
                    invalid_opcode = 1'b1;
            end

            // Check if datapath completed
            if (done) begin
                pc_next = pc_reg + 1; // incremement memory address
                next_state = FETCH; // fetch next instruction
            end else begin
                next_state = EXECUTE;
            end
        end

        default: next_state = WAIT;

    endcase
end

    // Output assignments
    assign pc = pc_reg;
    assign opcode = instruction[INSTR_LEN-1:INSTR_LEN - 4]; //opcode is instruct[19:16]
    a = instruction[INSTR_LEN - 5:INSTR_LEN - 12]; //a is instruct[15:8]
    b = instruction[INSTR_LEN - 13:0]; //b is instruct[7:0]

endmodule










