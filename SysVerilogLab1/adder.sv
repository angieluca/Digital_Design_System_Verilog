//Name: Angela Luca
//Section: #23200
//4 bit ripple carry adder

module adder (
  input  logic [3:0] input1,
  input  logic [3:0] input2,
  input  logic       carry_in,
  output logic [3:0] sum,
  output logic       carry_out
);

//Internal carry signals (Wires)
logic carry1, carry2, carry3;

//Structural architecture of 4 bit ripple carry adder
fa fa1( .input1(input1[0]), 
        .input2(input2[0]), 
        .carry_in(carry_in),
        .sum(sum[0]),
        .carry_out(carry1) );

fa fa2( .input1(input1[1]), 
        .input2(input2[1]), 
        .carry_in(carry1),
        .sum(sum[1]),
        .carry_out(carry2) );

fa fa3( .input1(input1[2]), 
        .input2(input2[2]), 
        .carry_in(carry2),
        .sum(sum[2]),
        .carry_out(carry3) );

fa fa4( .input1(input1[3]), 
        .input2(input2[3]), 
        .carry_in(carry3),
        .sum(sum[3]),
        .carry_out(carry_out) );

endmodule
