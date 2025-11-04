

module adder_tb;

  // DUT signals
  logic [3:0] input1, input2, sum;
  logic carry_in, carry_out;

  // Instantiate the Device Under Test (DUT)
  adder UUT (
    .input1    (input1),
    .input2    (input2),
    .carry_in  (carry_in),
    .sum       (sum),
    .carry_out (carry_out)
  );

  // Test all combinations of 4-bit inputs and carry_in
  initial begin

    // Helper variables
    logic [3:0] expected_sum;
    logic       expected_carry;
    int total;


    for (int i = 0; i < 16; i++) begin
      for (int j = 0; j < 16; j++) begin
        for (int k = 0; k < 2; k++) begin

          input1   = i;
          input2   = j;
          carry_in = k;

          #40; // Wait 40 ns for outputs to settle

          // Expected results
          total = i + j + k;
          expected_sum   = total[3:0];
          expected_carry = (total > 15) ? 1'b1 : 1'b0;

          // Assertions
          if (sum !== expected_sum) begin
            $display("ERROR: Sum incorrect for input1=%0d, input2=%0d, carry_in=%0d -> sum=%0b (expected=%0b)",
                      i, j, k, sum, expected_sum);
          end

          if (carry_out !== expected_carry) begin
            $display("ERROR: Carry incorrect for input1=%0d, input2=%0d, carry_in=%0d -> carry_out=%0b (expected=%0b)",
                      i, j, k, carry_out, expected_carry);
          end

        end
      end
    end

    $display("SIMULATION FINISHED!");
    $finish;

  end

endmodule
