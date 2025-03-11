module password(
    input clk,
    input rst,
    input [9:0] SW,
    output reg [3:0] pswd_out_LED,
    output reg [6:0] HEX0, HEX1, HEX2, HEX3, HEX4
);

localparam IDLE=0;
localparam DIGIT1=1;
localparam DIGIT2=2;
localparam DIGIT3=3;
localparam DONE=4;
localparam ERROR=5;

wire [9:0] pswd_in_SW;
reg [2:0] active_state=0;
wire slow_clk;

password_clock_divider DIVIDIR(
	.clk(clk),
	.rst(rst),
	.clk_div(slow_clk)
);

genvar i;
generate
    for (i = 0; i < 10; i = i + 1) begin : one_shot_instances
        one_shot BOTON (
            .clk(slow_clk),
            .button(SW[i]),
            .button_one_shot(pswd_in_SW[i])
        );
    end
endgenerate

always @(posedge slow_clk or negedge rst)
    begin
        if(~rst)
            begin
                active_state <= IDLE;
            end
        else
            begin
                case(active_state)
                    IDLE:
                        begin
                            pswd_out_LED <= 4'b0000;
									 HEX4 <= 7'b0000_000;
                            HEX3 <= 7'b0000_000;
                            HEX2 <= 7'b0000_000;
                            HEX1 <= 7'b0000_000;
                            HEX0 <= 7'b0000_000;
                            if(pswd_in_SW[2])
                                begin
                                active_state <= DIGIT1;
                                end
                            else if(|pswd_in_SW & ~pswd_in_SW[2])
                                begin
                                active_state <= ERROR;
                                end
                            else
                                begin
                                active_state <= IDLE;
                                end
                        end
                    DIGIT1:
                        begin
                            pswd_out_LED <= 4'b0001;
                            if(pswd_in_SW[0])
                                begin
                                active_state <= DIGIT2;
                                end
                            else if(|pswd_in_SW & ~pswd_in_SW[0] & ~pswd_in_SW[2])
                                begin
                                active_state <= ERROR;
                                end
                            else
                                begin
                                active_state <= DIGIT1;
                                end
                        end
                    DIGIT2:
                        begin
                            pswd_out_LED <= 4'b0011;
                            if(pswd_in_SW[1])
                                begin
                                active_state <= DIGIT3;
                                end
                            else if(|pswd_in_SW & ~pswd_in_SW[1] & ~pswd_in_SW[2] & ~pswd_in_SW[0])
                                begin
                                active_state <= ERROR;
                                end
                            else
                                begin
                                active_state <= DIGIT2;
                                end
                        end
                    DIGIT3:
                        begin
                            pswd_out_LED <= 4'b0111;
                            if(pswd_in_SW[6])
                                begin
                                active_state <= DONE;
                                end
                            else if(|pswd_in_SW & ~pswd_in_SW[6] & ~pswd_in_SW[2] & ~pswd_in_SW[1] & ~pswd_in_SW[0])
                                begin
                                active_state <= ERROR;
                                end
                            else
                                begin
                                active_state <= DIGIT3;
                                end
                        end
                    DONE:
                        begin
                            pswd_out_LED <= 4'b1111;
                            HEX4 <= 7'b1111_111;
                            HEX3 <= 7'b0100_001;
                            HEX2 <= 7'b1000_000;
                            HEX1 <= 7'b1001_000;
                            HEX0 <= 7'b0000_110;
                        end
                    ERROR:
                        begin
                            pswd_out_LED <= 4'b0000;
                            HEX4 <= 7'b0000_110;
                            HEX3 <= 7'b0101_111;
                            HEX2 <= 7'b0101_111;
                            HEX1 <= 7'b0100_011;
                            HEX0 <= 7'b0101_111;
						end
                endcase
            end
    end

endmodule