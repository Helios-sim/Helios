function QE=quantum_efficiency(input_data)

%Ska f� in en matris inneh�llandes olika frekvenser samt deras sp�nning.
%Kanske ta bort skapande/borttagning sessionerna, skicka in session som invariabel i s� fall.

s = daq.createSession('ni');
s.Rate = 100000;
ai0=s.addAnalogInputChannel('cDAQ1Mod3',0,'Voltage');
ai0.TerminalConfig = 'SingleEnded';

Fs=100000;
L=100000; 
[captured_data,time] = s.startForeground();


Y=fft(captured_data(:,1))/L;
f=linspace(0,Fs/2,Fs/2);
figure
plot(f,2*abs(Y(1:L/2)));

[PKS,LOCS] = findpeaks(abs(Y),'THRESHOLD',0.05);
PKS*2/1.22;
LOCS;

filtered_PKS = zeros(length(input_data(:,1)));

for i=1:length(input_data(:,1))
    index = find(LOCS, input_data(i,1));
    filtered_PKS(i) = PKS(index);
end
    
%M�ste finna amplituderna vid de inskickade frekvenserna, r�kna str�m,
%dividera med varje inskickat v�rde med matchande frekvens. S�tt detta som
%QE.

efficient_PKS = filtered_PKS./input_data(:,2);

QE(:,1) = efficient_PKS;
QE(:,2) = LOCS;

delete(s);

end