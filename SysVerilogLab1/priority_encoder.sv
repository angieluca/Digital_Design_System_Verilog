//Name: Angela Luca
//Section: #23200
//8bit priority encoder

module priority_encoder (
  input  logic [7:0] req,
  output logic [2:0] enc,
  output logic       valid //1 if any input is 1
);

always_comb begin
  //Default values
  valid = 1'b1;
  enc   = 3'b000;

  // Priority encoder: higher index has higher priority
  if      (req[7]) enc = 3'b111; 
  else if (req[6]) enc = 3'b110; 
  else if (req[5]) enc = 3'b101; 
  else if (req[4]) enc = 3'b100; 
  else if (req[3]) enc = 3'b011; 
  else if (req[2]) enc = 3'b010; 
  else if (req[1]) enc = 3'b001; 
  else if (req[0]) enc = 3'b000;
  else valid = 1'b0; //none of the inputs are 1 

end

endmodule
