module light_control_signal(
    input clk,
    input rst,
    input [3:0] data_in,
    input green_enable,
    input arrow_enable,
    input red_enable,
    input yellow_enable,
    output reg green,
    output reg arrow,
    output reg red,
    output reg yellow
);

//reg [3:0] AUX_green = 4'b0001;
//reg [3:0] AUX_arrow = 4'b0001;
//reg [3:0] AUX_red = 4'b0001;
//reg [3:0] AUX_yellow = 4'b0001;

always @(posedge clk)
    begin
        if(green_enable)
           count_max_green <= clk_freq/(2*data_in);
        else if(arrow_enable)
           count_max_arrow <= clk_freq/(2*data_in);
        else if(red_enable)
           count_max_red <= clk_freq/(2*data_in);
        else if(yellow_enable)
           count_max_yellow <= clk_freq/(2*data_in);
        else
            begin
                freq_green <= 4'b0001;
                freq_arrow <= 4'b0001;
                freq_red <= 4'b0001;
                freq_yellow <= 4'b0001;
            end
    end

reg [31:0] clk_freq = 50_000_000; //Cambiar a 3 para probar
reg [31:0] freq_green=4'b0001;
reg [31:0] freq_arrow=4'b0001;
reg [31:0] freq_red=4'b0001;
reg [31:0] freq_yellow=4'b0001;
reg [3:0] ctr_base=0;
reg [3:0] ctr_green=0;
reg [3:0] ctr_arrow=0;
reg [3:0] ctr_red=0;
reg [3:0] ctr_yellow=0;
reg [31:0]count_max_base = 25_000_000;
reg [31:0]count_max_green;
reg [31:0]count_max_arrow;
reg [31:0]count_max_red;
reg [31:0]count_max_yellow;

wire slow_clk; 
wire slow_clk_green;
wire slow_clk_arrow;
wire slow_clk_red;
wire slow_clk_yellow;

light_clock_divider BASE(
    .freq(1),
	.clk(clk),
    .rst(rst),
    .clk_div(slow_clk)
);

light_clock_divider VERDE(
    .freq(AUX_green),
    .clk(clk),
    .rst(rst),
    .clk_div(slow_clk_green)
);

light_clock_divider FLECHA(
    .freq(AUX_arrow),
    .clk(clk),
    .rst(rst),
    .clk_div(slow_clk_arrow)
);

light_clock_divider ROJO(
    .freq(AUX_red),
    .clk(clk),
    .rst(rst),
    .clk_div(slow_clk_red)
);

light_clock_divider AMARILLO(
    .freq(AUX_yellow),
    .clk(clk),
    .rst(rst),
    .clk_div(slow_clk_yellow)
);

localparam IDLE=0;
localparam GREEN_ARROW=1;
localparam GREEN=2;
localparam YELLOW=3;
localparam RED=4;

reg [2:0] active_state=0;

always @(posedge clk or posedge rst)
    begin
        if(rst)
		  begin
            active_state <= IDLE;
            ctr_green <= 0;
            ctr_arrow <= 0;
            ctr_red <= 0;
            ctr_yellow <= 0;
			end
        else
            begin
                case(active_state)
                    IDLE:
                        begin
                            ctr_green <= 0;
                            ctr_arrow <= 0;
                            ctr_red <= 0;
                            ctr_yellow <= 0;
                            green <= 1'b0;
                            arrow <= 1'b0;
                            red <= 1'b0;
                            yellow <= 1'b0;
                            if(ctr_base<count_max_base-1)
                                begin
                                active_state <= IDLE;
                                ctr_base <= ctr_base + 1;
                                end
                            else
                                active_state <= GREEN_ARROW;
                        end
                    GREEN_ARROW:
                        begin
                            green <= 1'b1;
                            arrow <= 1'b1;
                            red <= 1'b0;
                            yellow <= 1'b0;
                            if(ctr_arrow<count_max_arrow-1)
                                begin
                                active_state <= GREEN_ARROW;
                                ctr_arrow <= ctr_arrow + 1;
                                end
                            else
                                active_state <= GREEN;
                        end
                    GREEN:
                        begin
                            green <= 1'b1;
                            arrow <= 1'b0;
                            red <= 1'b0;
                            yellow <= 1'b0;
                            if(ctr_green<count_max_green-1)
                                begin
                                active_state <= GREEN;
                                ctr_green <= ctr_green + 1;
                                end
                            else
                                active_state <= YELLOW;
                        end
                    YELLOW:
                        begin
                            green <= 1'b0;
                            arrow <= 1'b0;
                            red <= 1'b0;
                            yellow <= 1'b1;
                            if(ctr_yellow<count_max_yellow-1)
                            begin
                                active_state <= YELLOW;
                                ctr_yellow <= ctr_yellow + 1;
                            end
                            else
                                active_state <= RED;
                        end
                    RED:
                        begin
                            green <= 1'b0;
                            arrow <= 1'b0;
                            red <= 1'b1;
                            yellow <= 1'b0;
                            if(ctr_red<count_max_red-1)
                            begin
                                active_state <= RED;
                                ctr_red <= ctr_red + 1;
                            end
                            else
                                active_state <= IDLE;
                        end
                    default:
                        begin
                            green <= 1'b0;
                            arrow <= 1'b0;
                            red <= 1'b0;
                            yellow <= 1'b0;
                            active_state <= IDLE;
                        end
                endcase
            end
    end
                    
endmodule