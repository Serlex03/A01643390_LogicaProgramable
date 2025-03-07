module counter (
    input clk,rst,enable, 
    output reg [3:0] count
);

always @(posedge clk) begin
    if (rst==1) 
		begin
        count<=4'b0000;
		end
        else if (enable==1) 
		  begin
            count<=count+1;
        end
    end

endmodule

//TestBench `timescale 100/1000us,
//          initial begin
//          clk=0; enable=0; rst=0;
//          #5 rst=1;
//          #10 rst=0;
//          #10 enable=1;
//          always
//          begin
//          #5 clk=~clk;
//          end