module mux2x1 #(
    parameter WIDTH = 16
)(
    input  logic               sel,
    input  logic [WIDTH-1:0]   a, b,
    output logic [WIDTH-1:0]   y
);
    always_comb begin
        y = (sel) ? b : a;
    end
endmodule
