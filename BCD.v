module BCD(
	input[9:0] BCD_in_sw,
	output wire[6:0] display_unidad, display_decena, display_centena, display_mil
);
	wire[3:0] AUX_unidades, AUX_decenas, AUX_centenas, AUX_mil;

	assign AUX_unidades = BCD_in_sw%10;
	assign AUX_decenas = BCD_in_sw%100/10;
	assign AUX_centenas = BCD_in_sw%1000/100;
	assign AUX_mil = BCD_in_sw/1000;
	
	BCD_decoder decoder_unidades (
		.decoder_in(AUX_unidades),
		.decoder_out(display_unidad)
	);
	BCD_decoder decoder_decenas (
		.decoder_in(AUX_decenas),
		.decoder_out(display_decena)
	);
	BCD_decoder decoder_centenas (
		.decoder_in(AUX_centenas),
		.decoder_out(display_centena)
	);
	BCD_decoder decoder_mil (
		.decoder_in(AUX_mil),
		.decoder_out(display_mil)
	);

endmodule