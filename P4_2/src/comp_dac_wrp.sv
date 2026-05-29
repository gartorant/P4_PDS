module comp_dac_wrp
(input signed [15:0] id_data, // S[16 15]
input ic_val_data, 
input clk,
output signed [13:0 ] od_data, // S[14 13]
output oc_val_data
);



// Seleccion de registros de I/O: 0-->no, 1-->si 
parameter reg_io = 1;

// No registra I/O
generate if (reg_io == 0)
	always_comb 	
		begin
		


		end
else
	always_ff@(posedge clk) 	
		begin
		


		end
endgenerate

// Instanciar comp_dac

// Asignación salidas

assign od_data =    ;
assign oc_val_data =    ;

endmodule