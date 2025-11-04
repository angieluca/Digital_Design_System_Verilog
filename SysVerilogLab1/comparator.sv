module comparator #(
    parameter WIDTH = 16
)(
    input  logic [WIDTH-1:0]   a, b,
    output logic               x_lt_y,
    output logic               x_ne_y
);
    assign x_lt_y = (a < b);
    assign x_ne_y = (a != b);
endmodule
