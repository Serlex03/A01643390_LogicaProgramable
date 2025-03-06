module PWM(
    input button_inc,
    input button_dec,
    input clk,
    input rst,
    output reg pwm_out,
	output clk_div
);

wire neg_button_inc = ~button_inc;
wire neg_button_dec = ~button_dec;
wire slow_clk;
wire debounced_button_inc; 
wire debounced_button_dec;
reg [31:0] ctr;

parameter base_freq = 'd50_000_000;
parameter target_freq = 'd50;
parameter counts = base_freq / target_freq;

//Cantidad de counts
reg [31:0] DC=70_000;

clock_divider DIVIDIR(
    .clk(clk),
	 .rst(rst),
    .clk_div(slow_clk) 
);

button_debouncer d0( neg_button_inc, clk, rst, debounced_button_inc);
button_debouncer d1( neg_button_dec, clk, rst, debounced_button_dec);

assign clk_div = slow_clk;

//Generar duty cycle
always @(posedge slow_clk or posedge rst)
    begin
        if(rst)
            begin
            DC <= 50_000;
            end
        else
            begin
			    if(neg_button_dec)
                begin
						if(DC>50_000)
							DC <= DC - 5_000; //El porcentaje a cambiar es fijo por el fabricante;
						else
							DC <= DC;
                end
                else if(neg_button_inc)
					begin
						if(DC<100_000)
							DC <= DC + 5_000;
						else
							DC <= DC;
					end
		        else
                begin
			    DC <= DC;
                end
            end
            
    end

//Always que cuente hasta que el DC llegue a la frecuencia indicada
//Always para contar el porcentaje y detenerse cuando termine el DC
// PWM_out <= 1
// if( las cuentas / no la frecuencia < DC)
always @(posedge clk)
    begin
		if (ctr < counts-1)
            begin
                ctr <= ctr + 1;
                if(ctr < DC)
                begin
                    pwm_out <= 1;
                end
                else
                begin
                    pwm_out <= 0;
                end
            end
        else
            begin
                ctr <= 0;
            end
    end

endmodule

module button_debouncer(
    input button_in,
	 input clk,
    input rst,
    output button_out
);

wire Q0, Q1, Q2, Q2_bar;
wire slow_clk;

clock_divider DIVIDIR(
    .clk(clk),
	 .rst(rst),
    .clk_div(slow_clk) 
);

d_ff d0( slow_clk, button_in, Q0);
d_ff d1( slow_clk, Q0, Q1);
d_ff d2( slow_clk, Q1, Q2);

assign Q2_bar = ~Q2;
assign button_out = Q1 & Q2_bar;

endmodule

module d_ff(
    input slow_clk,
    input D,
    output reg Q
);

always @(posedge slow_clk)
    begin
        Q <= D;
    end
endmodule

//Comentar lo siguiente para simular