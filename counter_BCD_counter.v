module BCD_counter(
	input[9:0] BCD_in_sw,
	output wire[6:0] display_unidad
);
	wire[3:0] AUX_unidades;

	assign AUX_unidades = BCD_in_sw%10;
	
	BCD_decoder decoder_unidades (
		.decoder_in(AUX_unidades),
		.decoder_out(display_unidad)
	);
endmodule
