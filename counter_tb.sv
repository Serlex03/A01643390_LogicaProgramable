module counter_tb;
    reg clk, rst, enable;
    wire [6:0] ctr;
    
    contador_1display DUT(
        .clk_P11(clk),
        .rst(rst),
        .BCD_7seg(ctr)
    );
	 
	 always #10 clk=~clk;
    
    initial begin
        clk=0; enable=0; rst=0;
        #100 rst=1;
        #100 rst=0;
        #100 enable=1;
		  #1000000 $stop;
        end

endmodule