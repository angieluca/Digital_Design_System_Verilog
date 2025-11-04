module GCD_Calculator #(
    parameter  int WIDTH  = 4
) (
    input  logic clk,
    input  logic rst,
    input  logic go,
    input  logic [ WIDTH-1:0] x,
    input  logic [ WIDTH-1:0] y,
    output logic [WIDTH-1:0] out,
    output logic done
);

    logic x_ne_y_from_datapath, x_lt_y_from_datapath, x_sel_to_datapath, x_en_to_datapath, y_sel_to_datapath, y_en_to_datapath, output_en_to_datapath;

    gcd_fsm controller(
    .clk(clk),
    .rst(rst),
    .go(go),
    .x_ne_y(x_ne_y_from_datapath), // signal coming from datapath
    .x_lt_y(x_lt_y_from_datapath), // signal coming from datapath
    .x_sel(x_sel_to_datapath), // signal going to datapath
    .x_en(x_en_to_datapath), // signal going to datapath
    .y_sel(y_sel_to_datapath), // signal going to datapath
    .y_en(y_en_to_datapath), // signal going to datapath
    .output_en(output_en_to_datapath), // signal going to datapath
    .done(done)
  );

    datapath #(.WIDTH(WIDTH)) datapath (
    .clk(clk),
    .rst(rst),
    .x(x),
    .y(y),
    .x_sel(x_sel_to_datapath),
    .x_en(x_en_to_datapath),
    .y_sel(y_sel_to_datapath),
    .y_en(y_en_to_datapath),
    .output_en(output_en_to_datapath),
    .x_lt_y(x_lt_y_from_datapath),
    .x_ne_y(x_ne_y_from_datapath),
    .out_data(out)
);

endmodule
