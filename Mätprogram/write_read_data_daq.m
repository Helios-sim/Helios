function [measurement_matrix, Time]=write_read_data_daq(number_of_points,start_voltage,stop_voltage,R)

s = daq.createSession('ni');

ai0 = s.addAnalogInputChannel('cDAQ1Mod3',0,'Voltage');
ai0.TerminalConfig = 'SingleEnded';



s.addAnalogOutputChannel('cDAQ1Mod1',0,'Voltage')


Time = linspace(start_voltage,stop_voltage, number_of_points)';
output_data = Time+start_voltage;

figure(1)
plot(output_data);
title('Output Data Queued');
s.queueOutputData([output_data]);

[captured_data,time] = s.startForeground();
figure(2)
plot(time,captured_data);
ylabel('Voltage');
xlabel('Time');
title('Acquired Signal');


measurement_matrix=captured_data;
measurement_matrix(:,2)=measurement_matrix(:,2)/R;



end




