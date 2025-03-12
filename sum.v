module sum(
    input clk,
    input rst,
    input [3:0] data_in,
    input sum_enable,
    output wire[0:6] display_unidad, display_decena, display_centena
);

wire [0:6] AUX_unidad;
wire [0:6] AUX_decena;
wire [0:6] AUX_centena;

reg [7:0] sum_out = 0;
reg [11:0] sum_BCD;

localparam IDLE=0;
localparam SUMA=1;
localparam FIN=2;

reg [1:0] active_state=0;
reg [7:0] ctr=1;



always @(posedge clk or posedge rst)
    begin
        if(rst)
            begin
            sum_out <= 8'b0;
            active_state <= IDLE;
            end
        else
            begin
                case(active_state)
                    IDLE:
                        begin
                            sum_out <= 8'b0;
                            if(sum_enable)
                                active_state <= SUMA;
                            else
                                active_state <= IDLE;
                        end
                    SUMA:
                        begin
                            sum_out <= sum_out + ctr;
                            if(ctr < data_in)
									 begin
                                active_state <= SUMA;
                                ctr <= ctr + 1;
										end
                            else
                                active_state <= FIN;
                        end
                    FIN:
                        begin
                            sum_out <= sum_out;
                        end
                endcase
            end
    end

    always @(posedge clk) begin
        sum_BCD[3:0]   <= sum_out % 10;        // Unidad
        sum_BCD[7:4]   <= (sum_out / 10) % 10; // Decena
        sum_BCD[11:8]  <= (sum_out / 100) % 10;// Centena
    end
	 
	 
	freq_decoder decoder_unidades (
		.decoder_in(sum_BCD[3:0]),
		.decoder_out(AUX_unidad)
	);
	freq_decoder decoder_decenas (
		.decoder_in(sum_BCD[7:4]),
		.decoder_out(AUX_decena)
	);
    freq_decoder decoder_centenas (
        .decoder_in(sum_BCD[11:8]),
        .decoder_out(AUX_centena)
    );

assign display_unidad = AUX_unidad;
assign display_decena = AUX_decena;
assign display_centena = AUX_centena;

endmodule