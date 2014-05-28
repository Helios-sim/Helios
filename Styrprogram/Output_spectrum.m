function Output_spectrum(handles)
try
handles = guidata(handles.figure1);
session = getappdata(handles.figure1,'session');
spec_session = getappdata(handles.figure1, 'spec_session');
appdata = getappdata(handles.figure1);
length_of_step = abs(appdata.from_iv - appdata.to_iv)/appdata.step_iv;

if length_of_step < 0.0012
    length_of_step = 0.0012;
end

voltage = (1/11)*[(appdata.from_iv):length_of_step:(appdata.to_iv - length_of_step)]';
chosen_spectrum = appdata.chosen_spectrum;
if failtest(chosen_spectrum)
    error('runtime:spectrumFault', 'The chosen spectrum contains illegal voltage levels');
end
spectrum = ones(1,length(voltage))'*(chosen_spectrum(1:15));
spec_session.outputSingleScan([chosen_spectrum(16)]);

%förbered data
led_power = ones(length(voltage),16);
Data = [led_power, voltage, spectrum];

%förbered DAQ-kortet för mätning
session.outputSingleScan([zeros(1,16) Data(1,17) zeros(1,15)]);
session.queueOutputData(Data);
session.prepare;

% mätningen utförs
[measure_data, timestamps, triggerTime] = session.startForeground;

% stäng av
session.queueOutputData(zeros(1,32));
session.prepare;
session.startForeground;
spec_session.outputSingleScan([0]);

% beräkningar utförs
process_data(measure_data, timestamps, handles);


catch err
    if strcmp(err.identifier, 'runtime:spectrumFault')
        session.outputSingleScan(1,32);
        spec_session.outputSingleScan([0]);
    else
        rethrow(err);
    end
end