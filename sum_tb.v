module sum_tb;

reg clk;
reg rst;
reg [3:0] data_in= 3;
reg sum_enable;

sum DUT(
	 .clk(clk),
	 .rst(rst),
	 .data_in(data_in),
	 .sum_enable(sum_enable)
);

always # 10 clk <= ~clk;

initial 
	begin
	
	clk = 0;
    rst = 0;
	 sum_enable = 0;
    # 100;
    rst = 1;
    # 100;
    rst = 0;

    # 100;
    sum_enable = 1;
    # 100;
end
endmodule