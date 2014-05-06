function Output_quantum_vibrations(handles)
session = getappdata(handles.figure1,'session');
spec_session = getappdata(handles.figure1, 'spec_session');
appdata = getappdata(handles.figure1);
datastep = session.Rate;
supply_voltage = 1;

voltage = supply_voltage*ones(datastep,1);
quantum_spectrum = appdata.quantum_spectrum;
spectrum = ones(1,datastep)'*(quantum_spectrum(1:15));
spec_session.outputSingleScan([quantum_spectrum(16)]);

[led_power, quantum_matrix] = createSquareWave(datastep, session.Rate);
setappdata(handles.figure1, 'quantum_matrix', quantum_matrix);
Data = [led_power, voltage, spectrum];
session.queueOutputData(Data);
session.prepare;
[measure_data, timestamps, triggerTime] = session.startForeground;
guidata(handles.figure1, handles);
process_data(measure_data, timestamps, handles)
end

