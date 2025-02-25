module BCD_tb #(parameter N=10, Iteraciones=10)();

reg [N-1:0] BCD_in_sw;

wire [0:6] display_unidad;
wire [0:6] display_decena;
wire [0:6] display_centena;
wire [0:6] display_mil;


BCD DUT(
    .BCD_in_sw(BCD_in_sw),
    .display_unidad(display_unidad),
    .display_decena(display_decena),
    .display_centena(display_centena),
    .display_mil(display_mil)
);

task set_input;
    BCD_in_sw = $urandom_range(0, 2**N-1);
    $display("Valor a probar = %d",BCD_in_sw);
    #10;
endtask

integer i;

initial begin
    for(i=0;i<Iteraciones;i=i+1) begin
        set_input;
    end
end

endmodule

//Explicar el codigo
//Se crea un modulo BCD_tb que tiene como parametros N y Iteraciones, 
//N es el tamaño de la entrada y el numero de bits de la misma, Iteraciones es el numero de veces que se va a probar el modulo BCD.