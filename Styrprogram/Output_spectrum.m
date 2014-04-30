function Output_spectrum(handles)
session = getappdata(handles.figure1,'session');
appdata = getappdata(handles.figure1);
%length_of_step = abs(appdata.to_iv - appdata.from_iv)/appdata.step_iv;
voltage = 1:1:(getappdata(handles.figure1, 'to_iv')); %[appdata.from_iv:1:appdata.to_iv]'; % - length_of_step)]'
cell_voltage = de2bi(voltage,16);
spectrum = ones(1,length(voltage))'*(appdata.chosen_spectrum);
led_power = ones(length(voltage),16);
Data = [led_power, cell_voltage, spectrum];
session.queueOutputData(Data);
session.prepare;
[measure_data, timestamps, triggerTime] = session.startForeground;
process_data(measure_data, timestamps, handles)
end

