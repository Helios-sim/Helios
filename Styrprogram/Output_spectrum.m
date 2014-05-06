function Output_spectrum(handles)
session = getappdata(handles.figure1,'session');
spec_session = getappdata(handles.figure1, 'spec_session');
appdata = getappdata(handles.figure1);
length_of_step = abs(appdata.from_iv - appdata.to_iv)/appdata.step_iv;

voltage = [1:length_of_step:(getappdata(handles.figure1, 'to_iv') - length_of_step)]';
chosen_spectrum = appdata.chosen_spectrum;
spectrum = ones(1,length(voltage))'*(chosen_spectrum(1:15));
spec_session.outputSingleScan([chosen_spectrum(16)]);

led_power = ones(length(voltage),16);
Data = [led_power, voltage, spectrum];
session.queueOutputData(Data);
session.prepare;
[measure_data, timestamps, triggerTime] = session.startForeground;
process_data(measure_data, timestamps, handles);
end