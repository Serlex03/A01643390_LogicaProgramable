module frecuenciometro_wr(
    output [0:6] HEX0, HEX1, HEX2, HEX3, HEX4, HEX5
);

	frecuenciometro WRAPPER(
    .display_unidad(HEX0[0:6]),
    .display_decena(HEX1[0:6]),
    .display_centena(HEX2[0:6]),
    .display_mil(HEX3[0:6]),
	 .display_dmil(HEX4[0:6]),
    .display_cmil(HEX5[0:6])
	);

endmodule