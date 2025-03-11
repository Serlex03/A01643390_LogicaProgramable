module password_wr(
	input MAX_CLK1_50,
	input [0:1]KEY,
    input [9:0] SW,
	 output [3:0] LEDR,
    output [0:6] HEX0, HEX1, HEX2, HEX3, HEX4
);

	BCD WRAPPER(
	.clk(MAX10_CLK1_50),
	.rst(KEY[0]),
    .SW(SW[9:0]),
	 .pswd_out_LED(LEDR[3:0]),
    .HEX0(HEX0[0:6]),
    .HEX1(HEX1[0:6]),
    .HEX2(HEX2[0:6]),
    .HEX3(HEX3[0:6]),
	 .HEX4(HEX4[0:6])

	);

endmodule