module datapath #(
    parameter WIDTH = 16
)(
    input  logic               clk,
    input  logic               rst,
    input  logic               x_sel,
    input  logic               x_en,
    input  logic               y_sel,
    input  logic               y_en,
    input  logic [WIDTH-1:0]   x,
    input  logic [WIDTH-1:0]   y,
    input  logic               output_en,
    output logic [WIDTH-1:0]   out_data,  
    output logic               x_lt_y,
    output logic               x_ne_y
);

    
// Your code here

endmodule
