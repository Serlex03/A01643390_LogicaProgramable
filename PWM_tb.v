module PWM_tb;

reg button_inc=1;
reg button_dec=1;
reg clk;
reg rst;
wire pwm_out;

PWM DUT(
    .button_inc(button_inc),
	 .button_dec(button_dec),
	 .clk(clk),
	 .rst(rst),
	 .pwm_out(pwm_out)
);

always # 10 clk <= ~clk;

initial 
	begin
	
	clk = 0;
    rst = 0;
    # 100;
    rst = 1;
    # 100;
    rst = 0;

    # 100;
    button_inc = 0;
    # 100;
    button_inc = 1;
    # 100;
    button_dec = 0;
    # 100;
    button_dec = 1;
end
endmodule