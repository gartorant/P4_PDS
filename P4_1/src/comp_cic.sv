module comp_cic
#(  parameter Win=16,     // Input Wordlength 
    parameter Wcoef = XX, // Coefficients Wordlength
    parameter Wout = 18,  // Output wordlength
    parameter Ng = XX,    // Filter growth
    parameter Num_coef=17)   // Coefficients number
(input  signed [Win-1:0] id_data_filter, // Input S[16 15]
 input ic_val_data,
 input ic_rst,
 input  clk, 
 output signed [Wout-1:0] od_data_filter, // S[18 15]
 output oc_val_data); 



/* DECLARACIONES ------------------------- */
// b0 CIC_PC





/* DESCRIPCION ------------------------- */
// b0 CIC_PC





/* ASIGNACION SALIDAS ------------------------- */

assign od_data_filter =  ;
assign oc_val_data = ;
/* DECLARACION FUNCION LOG2 ------------------------- */

function integer log2;
   input integer value;
   begin
     value = value-1;
     for (log2=0; value>0; log2=log2+1)
       value = value>>1;
   end
 endfunction
endmodule
