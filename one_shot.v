module one_shot (
    input clk,
    input button,
    output reg button_one_shot
);

reg delay;

always @(posedge clk)
    begin
        delay <= button;
        if((delay != button) && button == 1)
            begin
            button_one_shot <= 1;
            end
        else
            begin
            button_one_shot <= 0;
            end
    end

endmodule
