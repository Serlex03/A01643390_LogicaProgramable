module count_load (
    input clk,rst,load,up_down,
    input [3:0] data_in,
    output reg [3:0] count
);

always @(posedge clk or posedge rst)
begin
    if (rst) 
        begin
       count<=4'b0000;
        end
        else if (load) 
          begin
            count<=data_in;
        end
        else if (up_down) 
          begin
           count<=count+1;
        end
        else if (up_down==0) 
          begin
            count<=count-1;
        end
 end

endmodule
