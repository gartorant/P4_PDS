%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Generación de ficheros para Testeo del módulo comp_cic 
% 
%   Curso 2023-2024 - LAB P4_1:Compensador del CIC
%   Versión ALUMNOS
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
clear all
close all
warning ('off','all');
name_slx_model = 'comp_cic_model';
 % Name of the SV testbench
tsb_name = 'comp_cic_tsb';

% Choose full precision
full_precision = 0 % :1 Full precision 


% Generation of test files
file_test_gen = 1; %1-> yes; 0->no

% Open figures
open_figs = 0; %1-> yes; 0->no

% Directory to place the test files and the package for tsb.
file_dir = '../sim/iof/';
src_dir = '../src/'; 
tsb_dir = '../tsb/'; 


%% TEST CASES:
test_case = 2

% List of test cases
% 1 : Square signal fo=5 kHz
% 2 : Cosine signal fo=10 kHz
% 3 : Impulse 

switch test_case
    case 1 
        fo= 5; % kHz
        n_periods_to_display = 4; % #periods to display
       switch_case = 1;
    case 2     
        fo= 10; % kHz
        n_periods_to_display = 4; % #periods to display
        switch_case = 2;
    case 3 
        fo= 5; % kHz
        n_periods_to_display = 4; 
        switch_case = 3;
    otherwise
        error ('--> This test case is not defined <--') 
end

Tsim = n_periods_to_display*1e-3/(fo); %% Simulation time

%% ------------------Configuration-----------------------------------------

%% Configuracion del CIC

fsL=48;  %% Sample frequency (kHz)
R = 2000; %% Interpolator Factor
fsH = R*fsL/1000;  %% Clock frequency (MHz)
M=1; %% COMB 
N=3; %% CIC order


% ------------------Configuration END--------------------------------------

% % Compensador del CIC
order_comp_filter = 16;
f_max_comp = 0.4; % Máxima frec (normalizada) a compensar

f1=0:0.01:f_max_comp;
f=f1/(M*R);
resp=abs(sin(pi*f*R*M)./sin(pi*f)).^N;
resp = resp/max(abs(resp));
resp(1)=resp(2);
g_cic04=resp(end);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
if open_figs == 1
    figure(30)
    plot(f,20*log10(abs(resp)/2000));
    grid
    %axis([0 0.5/(M*R) abs(resp(2)/R)-8 abs(resp(2)/R)+0.2])
    ylabel('|H(f)| dBs')
    xlabel('f/f_{SH}')
    title(['CIC en el rango a compensar: R=' num2str(R) ' M=' num2str(M) ' N=' num2str(N)])
end

h_comp_cic=remez(order_comp_filter,2*[f1 0.5],[1./resp 1/resp(end)]);
h_comp_cic = round(h_comp_cic*2^16)*2^-16; %% Coeficientes comp cic cuantificados
[h,Wf]=freqz(h_comp_cic,1,1e5);


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Estudio de la cuantificación de la salida
%% A COMPLETAR POR EL ALUMNO
%% Realice los cálculos necesarios para hallar Ng a partir de la ganancia del filtro
Win = 16; %% Cuantificación entrada del filtro
Fin = 15;  %% Parte fraccional entrada del filtro 
Wcoef = 18; %% COMPLETAR Cuantificación de los coeficientes
Fcoef = 16; %% COMPLETAR Parte fraccional de los coeficientes

Ng = 18; % COMPLETAR Crecimiento del filtro

if full_precision == 1
    Wout = Win + Ng;
    Fout = Fcoef+Fin; 
else    
    Wout = 18;
    Fout = 15;
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Simulink
sim([ name_slx_model '.slx']) % Launch Simulink model

%% Graficas INPUT / OUTPUT
L_s_in= length(s_in);
L_sout = length(s_out);
if open_figs == 1
        subplot(2,1,1)
        plot((1:L_s_in),s_in(1:L_s_in))
        ylabel('s\_in(n)')
        xlabel('n')
        axis([0 L_s_in -1 1])
        title('Señal de entrada al compensador resp. CIC');
        subplot(2,1,2)
        plot((1:L_sout),s_out(1:L_sout));
        ylabel('s\_out(n)')
        axis([0 L_sout min(s_out) max(s_out)])
        xlabel('n')
        title('Señal de salida del compensador resp. CIC');
end
%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% Generacion de ficheros de datos para testear todos los módulos:       %
%%% - Entrada del compensador CIC                                         %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% COMPLETAR POR EL ALUMNO
if file_test_gen == 1
    %id_comp_cic.txt
    input_q = quantizer([Win Fin], ...
        'wrap', 'floor');   % Crea un cuantizador con formato [Win Fin], 
                            % saturación wrap y redondeo floor
    f = sprintf([file_dir 'id_comp_cic.txt']); % Construye la ruta completa 
                                               % del fichero de salida
    input_data_length = length(s_in_q);
    pack_f  = fopen(f,'w');
    for i = 1:input_data_length-1
        fprintf(pack_f,[num2bin(input_q, s_in_q(i)) '\n']); % Escribe la muestra 
                                                            % cuantizada en binario
    end
    fprintf(pack_f,[num2bin(input_q, s_in_q(i+1))]);
    fclose(pack_f);
end
%% - Salida del compensador CIC
%% COMPLETAR POR EL ALUMNO
if file_test_gen == 1
    %od_comp_cic.txt
    output_q = quantizer([Wout Fout], 'wrap', 'floor');
    f = sprintf([file_dir 'od_comp_cic.txt']);
    output_data_length = length(s_out_q);
    pack_f  = fopen(f,'w');
    for i = 1:output_data_length-1
        fprintf(pack_f,[num2bin(output_q, s_out_q(i)) '\n']);
    end
    fprintf(pack_f,[num2bin(output_q, s_out_q(i+1))]);
    fclose(pack_f);
end
%% - Fichero de coeficientes del compensador CIC
%% COMPLETAR POR EL ALUMNO
if file_test_gen == 1
    %rom_coefs_comp_cic.txt
    rom_coefs = quantizer([Wcoef Fcoef], 'wrap', 'floor');
    f = sprintf([file_dir 'rom_coefs_comp_cic.txt']);
    rom_coefs_length = length(h_comp_cic);
    pack_f  = fopen(f,'w');
    for i = 1:rom_coefs_length-1
        fprintf(pack_f,[num2bin(rom_coefs, h_comp_cic(i)) '\n']);
    end
    fprintf(pack_f,[num2bin(rom_coefs, h_comp_cic(i+1))]);
    fclose(pack_f);
end
%% - Fichero package con los parámetros: Win, Wcoef, Wout, Ng, Num_coef, full_precision, 
%% COMPLETAR POR EL ALUMNO
if file_test_gen == 1
    %comp_cic_tsb_pkg.sv
    f = sprintf([tsb_dir tsb_name '_pkg.sv']);
    pack_f = fopen(f, 'w');
    fprintf(pack_f, 'package %s_pkg; \n',tsb_name);
    fprintf(pack_f, '\n');
    fprintf(pack_f, 'integer test_case = %d; \n', test_case);
    fprintf(pack_f, 'integer input_data_length  = %d; \n', input_data_length);
    fprintf(pack_f, 'integer output_data_length = %d; \n', output_data_length);
    fprintf(pack_f, 'integer fo = %d; \n', fo);
    fprintf(pack_f, ' \n');
    
    fprintf(pack_f, 'parameter R = %d; \n', R);
    fprintf(pack_f, 'parameter Win = %d; \n', Win);
    fprintf(pack_f, 'parameter Wcoef = %d; \n', Wcoef);
    fprintf(pack_f, 'parameter Wout  = %d; \n', Wout);
    fprintf(pack_f, 'parameter Ng    = %d; \n', Ng);
    fprintf(pack_f, 'parameter rom_coefs = %d; \n', rom_coefs_length);
    fprintf(pack_f, 'parameter full_precision = %d; \n', full_precision);
    fprintf(pack_f, '\n');

    fprintf(pack_f, 'endpackage');
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%