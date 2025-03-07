module contador_1display (
    input clk_P11, rst, up_down, load,
	 input [3:0] data_in,
    output [0:6] BCD_7seg,
	 
	 output clk_led
	 
);

wire [3:0] AUX_counter;
wire clk_div_output;


clock_divider DIVIDIR(
    .clk(clk_P11),
	 .rst(rst),
    .clk_div(clk_div_output) 
);

count_load CONTAR(
    .clk(clk_div_output),
    .rst(rst),
	 .load(load),
	 .data_in(data_in),
    .up_down(up_down),
    .count(AUX_counter)
);

BCD_counter MOSTRAR(
    .BCD_in_sw(AUX_counter),
    .display_unidad(BCD_7seg)
);


assign clk_led = clk_div_output;

endmodule