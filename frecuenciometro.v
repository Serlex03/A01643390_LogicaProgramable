module frecuenciometro (
    input wire clk,
    input wire rst,
    input wire signal_in,
    output wire[0:6] display_unidad, display_decena, display_centena, display_mil, display_dmil, display_cmil
);

    reg [31:0] pulse_count = 0;
    reg [31:0] time_count = 0;
    reg [31:0] frequency = 0;
    reg prev_signal = 0;
	 
	 wire [0:6] AUX_unidad;
     wire [0:6] AUX_decena;
     wire [0:6] AUX_centena;
     wire [0:6] AUX_mil;
     wire [0:6] AUX_dmil;
     wire [0:6] AUX_cmil;

    localparam BASE_TIME = 50_000_000;

    reg [23:0] freq_bcd;
    reg [2:0] display_select;
    reg [3:0] current_digit;
    reg [19:0] refresh_count;

    always @(posedge clk) begin
        if (rst) 
        begin
            pulse_count <= 0;
            time_count <= 0;
            frequency <= 0;
        end 
        else 
        begin
            if (prev_signal == 0 && signal_in == 1)
                pulse_count <= pulse_count + 1;
                prev_signal <= signal_in;
            
            if (time_count < BASE_TIME) 
            begin
                time_count <= time_count + 1;
            end 
            else 
            begin
                frequency <= pulse_count;
                pulse_count <= 0;
                time_count <= 0;
            end
        end
    end

    always @(posedge clk) begin
        freq_bcd[3:0]   <= frequency % 10;        // Unidad
        freq_bcd[7:4]   <= (frequency / 10) % 10; // Decena
        freq_bcd[11:8]  <= (frequency / 100) % 10;// Centena
        freq_bcd[15:12] <= (frequency / 1000) % 10;// Millar
        freq_bcd[19:16] <= (frequency / 10000) % 10;// Decena de millar
        freq_bcd[23:20] <= (frequency / 100000) % 10;// Centena de millar
    end
	 
	 
	freq_decoder decoder_unidades (
		.decoder_in(freq_bcd[3:0]),
		.decoder_out(AUX_unidad)
	);
	freq_decoder decoder_decenas (
		.decoder_in(freq_bcd[7:4]),
		.decoder_out(AUX_decena)
	);
	freq_decoder decoder_centenas (
		.decoder_in(freq_bcd[11:8]),
		.decoder_out(AUX_centena)
	);
	freq_decoder decoder_mil (
		.decoder_in(freq_bcd[15:12]),
		.decoder_out(AUX_mil)
	);
    freq_decoder decoder_dmil (
		.decoder_in(freq_bcd[19:16]),
		.decoder_out(AUX_dmil)
	);
	freq_decoder decoder_cmil (
		.decoder_in(freq_bcd[23:20]),
		.decoder_out(AUX_cmil)
	);

    assign display_unidad = AUX_unidad;
    assign display_decena = AUX_decena;
    assign display_centena = AUX_centena;
    assign display_mil = AUX_mil;
    assign display_dmil = AUX_dmil;
    assign display_cmil = AUX_cmil;


endmodule