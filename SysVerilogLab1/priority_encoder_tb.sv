

module priority_encoder_tb;

  logic [7:0] req;
  logic [2:0] enc;
  logic       valid;

  
  priority_encoder dut (
    .req   (req),
    .enc   (enc),
    .valid (valid)
  );

  
  initial begin
    $display("Starting Priority Encoder Test...");
    
    // Test each input bit set individually (one-hot)
    for (int i = 0; i < 8; i++) begin
      req = 8'b0;
      req[i] = 1'b1;

      #10; // Wait for output to settle
      
      $display("req = %b => enc = %b, valid = %b", req, enc, valid);

      if (enc !== i[2:0] || valid !== 1'b1)
        $display("ERROR: Expected enc = %b, valid = 1 for input %0d", i[2:0], i);
    end

    // Test multiple bits high (should prioritize highest)
    req = 8'b10010010; // bits 7, 4, and 1 are high
    #10;
    $display("req = %b => enc = %b, valid = %b", req, enc, valid);
    if (enc !== 3'b111)
      $display("ERROR: Expected highest priority (bit 7) => enc = 111");

    req = 8'b00011000; // bits 4 and 3 are high
    #10;
    $display("req = %b => enc = %b, valid = %b", req, enc, valid);
    if (enc !== 3'b100)
      $display("ERROR: Expected highest priority (bit 4) => enc = 100");

    // Test all zero input (no request)
    req = 8'b00000000;
    #10;
    $display("req = %b => enc = %b, valid = %b", req, enc, valid);
    if (valid !== 1'b0)
      $display("ERROR: Expected valid = 0 for all-zero input");

    $display("Test completed.");
    $finish;
  end

endmodule
