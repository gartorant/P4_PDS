module comp_dac
#(parameter Win=16,  // Module input wordlength
parameter Wout = 14) // Module output wordlength
(input signed [Win-1:0] id_data, // S[Win, Win-1]
input ic_val_data, 
input clk,
output signed [Wout-1:0 ] od_data, // S[Wout, Wout-1]
output oc_val_data
);

/* DECLARACIONES ------------------------- */

// b0 



/* DESCRIPCION ------------------------- */

// Comp_DAC Full precision



/* ASIGNACION SALIDAS ------------------------- */

assign od_data = ;
assign oc_val_data =  ;

endmodule
