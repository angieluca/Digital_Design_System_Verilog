//============================================================
// Testbench for Dice Logic
// Demonstrates constraint Random value generation
//============================================================

module tb2_dice_logic;

  // ----------------------------------------------------------
  // Clock
  // ----------------------------------------------------------
  logic clk = 0;
  always #5 clk = ~clk; 

  // ----------------------------------------------------------
  // DUT I/O
  // ----------------------------------------------------------
  logic [4:0] die1, die2;
  logic [5:0] sum;
  logic double_flag, odd_sum, even_sum;

  // DUT Instantiation
  dice_logic dut (
    .die1(die1),
    .die2(die2),
    .sum(sum),
    .double_flag(double_flag),
    .odd_sum(odd_sum),
    .even_sum(even_sum)
  );

  // ----------------------------------------------------------
  // Stimulus Class
  // ----------------------------------------------------------
  class DiceStimulus;
    rand int die1_val; 			// Only 1-20 are the legal values; 0, 21-32 are illegal values
    rand int die2_val;			// Only 1-20 are the legal values; 0, 21-32 are illegal values


    // --- Legitimate values constraint
    constraint legit_c { die1_val inside {[1:20]}; die2_val inside {[1:20]}; }


    // Weighted constraint favor high probability rolls
    constraint weighted_c {
      die1_val dist {[1:4] := 7, [5:15] := 3, [16:20] := 7};
      die2_val dist {[1:4] := 7, [5:15] := 3, [16:20] := 7};
    }



  endclass

  DiceStimulus stim = new();		//object creation

 // ----------------------------------------------------------
  // Functional Coverage
  // ----------------------------------------------------------

covergroup cg @(posedge clk);

  coverpoint die1 {
    bins Valid_faces[]   = {[1:20]};   // Named bin for valid range
    bins Invalid_faces[] = {0,[21:31]};  // Named bin for invalid range
  }

  coverpoint die2 {
    bins Valid_faces[]   = {[1:20]};      // Valid range
    bins Invalid_faces[] = {0,[21:31]};   // Invalid values
  }

endgroup


  cg coverage = new();



  // ----------------------------------------------------------
  // Test Sequence
  // ----------------------------------------------------------
  initial begin
 
    // Randomize and test multiple times
    repeat (50) begin
      assert(stim.randomize()) else $fatal("Randomization failed!");

      // Apply to DUT
      die1 = stim.die1_val;
      die2 = stim.die2_val;
      @(posedge clk);

      // Functional Coverage

      //   coverage.sample();  This sample() function can be used to explicitly 
      //                       sample and record the coverpoints. However it is not
      //                       necessary here because it is sampled @(posedge clk:
      //  
    

      // Checks or assertions
      assert (sum == (die1 + die2)) else 
        $error("Sum mismatch! Expected %0d, got %0d", die1 + die2, sum);

      assert (double_flag == (die1 == die2)) else
        $error("Double flag incorrect!");

      assert (!(odd_sum && even_sum)) else
        $error("Odd/Even flags overlap!");

      $display("DIE1=%0d  DIE2=%0d  SUM=%0d  DOUBLE=%0b  ODD=%0b EVEN=%0b",
               die1, die2, sum, double_flag, odd_sum, even_sum);
    end

	// Report coverage
    $display("\nFinal Coverage = %0.2f%%", coverage.get_inst_coverage());
    $display("\nSimulation Completed Successfully!");
    $finish;
  end

endmodule
