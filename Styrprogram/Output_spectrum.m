function Output_spectrum(handles)
try
handles = guidata(handles.figure1);
session = getappdata(handles.figure1,'session');
spec_session = getappdata(handles.figure1, 'spec_session');
appdata = getappdata(handles.figure1);
length_of_step = abs(appdata.from_iv - appdata.to_iv)/appdata.step_iv;

voltage = [(appdata.from_iv):length_of_step:(appdata.to_iv - length_of_step)]';
chosen_spectrum = appdata.chosen_spectrum;
if failtest(chosen_spectrum)
    error('runtime:spectrumFault', 'The chosen spectrum contains illegal voltage levels');
end
spectrum = ones(1,length(voltage))'*(chosen_spectrum(1:15));
spec_session.outputSingleScan([chosen_spectrum(16)]);

led_power = ones(length(voltage),16);
Data = [led_power, voltage, spectrum];
session.queueOutputData(Data);
session.prepare;

% mätningen utförs
[measure_data, timestamps, triggerTime] = session.startForeground;

% beräkningar utförs
process_data(measure_data, timestamps, handles);

% stäng av
session.queueOutputData(zeros(1,32));
spec_session.outputSingleScan([0]);
session.prepare;
session.startForeground;

catch err
    if strcmp(err.identifier, 'runtime:spectrumFault')
        session.outputSingleScan(1,32);
        spec_session.outputSingleScan([0]);
    else
        rethrow(err);
    end
end