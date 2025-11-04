//Name: Angela Luca
//Section: #23200
//1 bit Full adder in SystemVerilog

module fa (
  input  logic input1,
  input  logic input2,
  input  logic carry_in,
  output logic sum,
  output logic carry_out
);

always_comb begin

  //Set default values
  carry_out = 1'b0;
  sum = '0; 

  //Combinatorial (behavioral architecture) addition of 1 bit values
  sum = input1 ^ input2 ^ carry_in; // ^ = XOR
  carry_out = (input1 & input2) | (carry_in & input1) | (carry_in & input2);

end 

endmodule
