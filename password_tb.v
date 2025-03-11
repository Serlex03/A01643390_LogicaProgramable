module password_tb;

reg clk = 0;
reg rst = 1;
reg [9:0] SW = 0;
wire [3:0] pswd_out_LED = 0;

password DUT(
	.clk(clk),
	.rst(rst),
	.SW(SW[9:0]),
	.pswd_out_LED(pswd_out_LED[3:0])
);

always #10 clk = ~clk;

initial
begin
    #1000;
	 rst = 0;
    #1000;
    rst = 1;

    #1000;
    SW[2] = 1;
	 #1000;
	 SW[2] = 0;
	 #1000;
	 SW[0] = 1;
	 #1000;
	 SW[0] = 0;
	 #1000;
	 SW[1] = 1;
	 #1000;
	 SW[1] = 0;
	 #1000;
	 SW[6] = 1;
	 #1000;
	 SW[6] = 0;
	 #1000;
end

endmodule