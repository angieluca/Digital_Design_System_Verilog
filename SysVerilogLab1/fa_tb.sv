`timescale 1ns/1ps

module fa_tb;

  // DUT signals
  logic input1, input2, carry_in;
  logic sum, carry_out;

  // Instantiate the DUT (Device Under Test)
  fa UUT (
    .input1    (input1),
    .input2    (input2),
    .carry_in  (carry_in),
    .sum       (sum),
    .carry_out (carry_out)
  );

  // Test process
  initial begin
    logic [2:0] temp;

    for (int i = 0; i < 8; i++) begin
      temp = i[2:0];  // Get 3-bit vector from loop index
      input1    = temp[2];
      input2    = temp[1];
      carry_in  = temp[0];

      #40; // Wait for 40 ns

      // Assertions (manual form since SystemVerilog doesn't have VHDL-style assert keywords)
      if (sum !== (input1 ^ input2 ^ carry_in))
        $display("Sum failed for i=%0d: input1=%b, input2=%b, carry_in=%b, sum=%b", i, input1, input2, carry_in, sum);

      if (carry_out !== ((input1 & input2) | (input1 & carry_in) | (input2 & carry_in)))
        $display("Carry failed for i=%0d: input1=%b, input2=%b, carry_in=%b, carry_out=%b", i, input1, input2, carry_in, carry_out);
    end

    $display("SIMULATION FINISHED!");
    $finish;
  end

endmodule
