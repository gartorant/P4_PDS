%% Compensacion del DAC
h_comp_DAC=[-1/16 1-2^-3 -1/16];

[H,Wf]=freqz(h_comp_DAC);
H(1)=H(2);
%H = H/max(abs(H));
if open_figs == 1
    figure(20)
    subplot(3,1,1)
    plot(Wf/(2*pi),20*log10(abs(H)));
    
    grid
    ylabel('|H(f)| dBs')
    xlabel('f/f_{SH}')
    title(['FIR compensador DAC'])
end

% DAC
R=10;M=1;N=1;
hdac=ones(M*R,1);
[H,Wf]=freqz(hdac/(sum(hdac)));
H(1)=H(2);

if open_figs == 1
    figure(20)
    subplot(3,1,2)
    plot(R*Wf/(2*pi),20*log10(abs(H)),'-r');
    axis([0 0.5 -4 0.2])
    grid
    ylabel('|H(f)| dBs')
    xlabel('f/f_{SH}')
    title(['Respuesta DAC'])
    hfinal=conv(hdac,upsample(h_comp_DAC,R)/R);
    [h,Wf]=freqz(hfinal,1,1e5);
    
    
    figure(20)
    subplot(3,1,3)
    plot(R*Wf/(2*pi),20*log10(abs(h)));
    grid
    hold on
    [H,Wf]=freqz(hdac/(sum(hdac)));
    H(1)=H(2);
    plot(R*Wf/(2*pi),20*log10(abs(H)),'r');
    axis([0 0.5 -4 0.2])
    ylabel('|H(f)| dBs')
    xlabel('f/f_{SH}')
    title(['Compensación del DAC'])
    legend('DAC compensado',['DAC'])
    hold off
end

