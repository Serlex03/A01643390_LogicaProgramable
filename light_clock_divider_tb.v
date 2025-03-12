module light_clock_divider_tb;

reg freq = 25_000_000; // Frecuencia deseada en Hz
reg clk = 0;
reg rst = 1;
wire clk_div;

light_clock_divider DUT(
	.freq(freq),
	.clk(clk),
	.rst(rst),
	.clk_div(clk_div)
);

always #10 clk = ~clk;

initial
begin
    #100;
	 rst = 0;
    #100;
    rst = 1;
	 #100; 

end

endmodule