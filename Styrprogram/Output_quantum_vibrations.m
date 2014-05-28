function Output_quantum_vibrations(handles)
try
session = getappdata(handles.figure1,'session');
spec_session = getappdata(handles.figure1, 'spec_session');
appdata = getappdata(handles.figure1);
datastep = session.Rate;

voltage = zeros(datastep,1);%*(1/11);
quantum_spectrum = appdata.quantum_spectrum;

spectrum = ones(1,datastep)'*(quantum_spectrum(1:15));
spec_session.outputSingleScan([quantum_spectrum(16)]);

[led_power, quantum_matrix] = createSquareWave(datastep, datastep);

spectrum(:,8) = quantum_spectrum(8)*led_power(:,8);
spectrum(:,14) = quantum_spectrum(14)*led_power(:,14);

setappdata(handles.figure1, 'quantum_matrix', quantum_matrix);

if failtest(quantum_spectrum)
    error('runtime:spectrumFault','The spectrum specified for the quantum frequency measurement is faulty.');
end
Data = [led_power, voltage, spectrum];
session.queueOutputData(Data);
session.prepare;
%m�tning utf�rs
[measure_data, timestamps, triggerTime] = session.startForeground;
shutdown_simulator(handles);
%ber�kningar utf�rs
process_data(measure_data, timestamps, handles)
catch err
    if strcmp(err.identifier, 'runtime:spectrumFault')
        disp(err.message);
        shutdown_simulator(handles);
    else
        rethrow(err);
    end
end
end

