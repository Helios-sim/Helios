function write_read_data_daq

s = daq.createSession('ni')
ai0=s.addAnalogInputChannel('cDAQ2Mod3',0,'Voltage')
ai0.TerminalConfig = 'SingleEnded'

ai1=s.addAnalogInputChannel('cDAQ2Mod3',1,'Voltage')
ai1.TerminalConfig = 'SingleEnded'

s.addAnalogOutputChannel('cDAQ2Mod1',0,'Voltage')
s.addAnalogOutputChannel('cDAQ2Mod1',1,'Voltage')

output_data = sin(linspace(0,2*pi,1000)');

figure(1)
plot(output_data);
title('Output Data Queued');

output_data2 = sin(linspace(0,4*pi,1000)');
s.queueOutputData([output_data output_data2])
figure(3)
plot(output_data2);
title('Output Data2 Queued');

[captured_data,time] = s.startForeground();
figure(2)
plot(time,captured_data(:,1));
ylabel('Voltage');
xlabel('Time');
title('Acquired Signal');

figure(4)
plot(time,captured_data(:,2));
ylabel('Voltage');
xlabel('Time');
title('Acquired Signal');

end




