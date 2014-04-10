function QE=quantum_efficiency()

s = daq.createSession('ni')
s.Rate = 100000
ai0=s.addAnalogInputChannel('cDAQ1Mod3',0,'Voltage');
ai0.TerminalConfig = 'SingleEnded';
ai1=s.addAnalogInputChannel('cDAQ1Mod3',1,'Voltage');
ai1.TerminalConfig = 'SingleEnded';

Fs=100000;
L=100000; 
[captured_data,time] = s.startForeground();


Y=fft(captured_data(:,1))/L;
Y1=fft(captured_data(:,2))/L;
f=linspace(0,Fs/2,Fs/2);
figure
plot(f,2*abs(Y(1:L/2)));
figure
plot(f,2*abs(Y1(1:L/2)));

[PKS,LOCS] = findpeaks(abs(Y),'THRESHOLD',0.05);
PKS*2/1.22
LOCS

val = 40000;
tmp = abs(f-val);
[idx idx] = min(tmp)
true_value = 2*abs(Y(idx))/1.22
another_value = 2*abs(Y(idx + 1))/1.22

Qe=1;
end