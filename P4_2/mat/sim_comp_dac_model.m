%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Generación de ficheros para Testeo del módulo comp_cic 
% 
%   Curso 2023-2024 - LAB P4_2:Compensador del DAC
%   Versión ALUMNOS
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
clear all
close all
warning ('off','all');
name_slx_model = 'comp_dac_model';
% Name of the SV testbench
tsb_name = 'comp_DAC';
fsH = 96e6;

% Choose full precision
full_precision = 1 % :1 Full precision 
if full_precision == 1
    Win=16;
    Fin=15;
    %Wout = XX; %% COMPLETAR ALUMNOS
    %Fout = XX; %% COMPLETAR ALUMNOS
else  
    Win=16;
    Fin=15;
    Wout = 14;
    Fout = 13;
end


% Generation of test files
file_test_gen = 1; %1-> yes; 0->no

% Open figures
open_figs = 1; %1-> yes; 0->no

% Directory to place the test files and the package for tsb.
file_dir = '../sim/iof/';
src_dir = '../src/'; 
tsb_dir = '../tsb/'; 


%% TEST CASES:
test_case = 1;

% List of test cases
% 1 : Cosine signal fo=40MHz
% 2 : Cosine signal fo=20MHz
% 3 : Impulse 


switch test_case
    case 1 
        fo= 40e6; % 
        n_periods_to_display = 10; % #periods to display
        switch_case = 1;
    case 2     
        fo = 20e6;
        n_periods_to_display = 10; % #periods to display
        switch_case = 1;
    case 3 
        fo= fsH/2;
        n_periods_to_display = 10; 
        switch_case = 2; 
    otherwise
        error ('--> This test case is not defined <--') 
end

Tsim = n_periods_to_display/(fo); %% Simulation time

%% ------------------Configuration-----------------------------------------

conf_comp_dac %% Carga coefts h_comp_DAC


%% Simulink
sim([ name_slx_model '.slx']) % Launch Simulink model
s_in = ans.s_in;
s_out = ans.s_out;

%% Graficas INPUT / OUTPUT
L_s_in= length(s_in);
L_sout = length(s_out);
if open_figs == 1
        figure(30);
        subplot(2,1,1)
        plot((1:L_s_in),s_in(1:L_s_in))
        ylabel('s\_in(n)')
        xlabel('n')
        axis([0 L_s_in -1 1])
        title('Señal de entrada al compensador resp. DAC');
        subplot(2,1,2)
        plot((1:L_sout),s_out(1:L_sout));
        ylabel('s\_out(n)')
        axis([0 L_sout min(s_out) max(s_out)])
        xlabel('n')
        title('Señal de salida del compensador resp. DAC');
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Generacion de ficheros de datos para testear todos los módulos:
%% - Entrada del compensador DAC
%% - Salida del compensador DAC
%% - Package with parameters (Win, Wout, full_precision)


if file_test_gen == 1

%% COMPLETAR POR ALUMNOS

end