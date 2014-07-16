function Output_quantum_vibrations(handles)
try
appdata = getappdata(handles.figure1);
debug = getappdata(handles.figure1, 'debug_mode');
session = appdata.session;
datalength = session.Rate;
quantum_spectrum = appdata.quantum_spectrum;
[led_vibration, frequency_matrix] = createMatrixWave(handles);
setappdata(handles.figure1, 'quantum_matrix', frequency_matrix);

for i = 1:length(quantum_spectrum)
spectrum = quantum_spectrum(i)*led_vibration(:,i);
end
if failtest(quantum_spectrum)
    error('runtime:spectrumFault','The spectrum specified for the quantum frequency measurement is faulty.');
end

if debug
    disp('in OuputQuantumVibrations: ');
    disp(quantum_spectrum);
end

Data = [spectrum];
session.queueOutputData(Data);
session.prepare;

% mätning utförs
[measure_data, timestamps, triggerTime] = session.startForeground;
shutdown_simulator(handles);
% beräkningar utförs och resultat presenteras för användaren
process_data(measure_data, timestamps, handles)

catch err
    if strcmp(err.identifier, 'runtime:spectrumFault')
        disp(strcat(err.identifier, ': ', err.message));
        shutdown_simulator(handles);
    else
        disp(strcat(err.identifier, ': ', err.message));
        rethrow(err);
    end
end
end

