function process_data(data, timestamps, handles)
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here
handles = guidata(handles.figure1);
debug = getappdata(handles.figure1, 'debug_mode');
voltage = data(:,1);
current = convert_to_current(data(:,2), getappdata(handles.figure1,'R'));
switchCase = getappdata(handles.figure1, 'measurement_type');
if debug
    disp('voltage: ');
    disp(size(voltage));
    disp('current: ');
    disp(size(current));
    disp(strcat('case: ', switchCase));
end
switch(switchCase)
    case('specificSpectrum')
        spectrum_efficiency(data, handles)
    case('QuantumEfficiency')
        quantum_efficiency(data, handles, debug);
    otherwise
        return;
end
guidata(handles.figure1, handles);
end