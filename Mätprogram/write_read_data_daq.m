function [measurement_matrix, Time]=write_read_data_daq(number_of_points,start_voltage,stop_voltage,R)

% sessionen ska tas bort ur koden efter att mätprogramdelen testats klart
s = daq.createSession('ni')
ai0=s.addAnalogInputChannel('cDAQ1Mod3',0,'Voltage')
ai0.TerminalConfig = 'SingleEnded'

ai1=s.addAnalogInputChannel('cDAQ1Mod3',1,'Voltage')
ai1.TerminalConfig = 'SingleEnded'

s.addAnalogOutputChannel('cDAQ1Mod1',0,'Voltage')
s.addAnalogOutputChannel('cDAQ1Mod1',1,'Voltage')

Time = linspace(start_voltage,stop_voltage, number_of_points)';
output_data = Time+start_voltage;

figure(1)
plot(output_data);
title('Output Data Queued');

output_data2 =output_data;
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

measurement_matrix=captured_data;
measurement_matrix(:,2)=measurement_matrix(:,2)/R;

end




