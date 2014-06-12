function process_data(data, timestamps, handles)
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here
try
    handles = guidata(handles.figure1);
    switchCase = getappdata(handles.figure1, 'measurement_type');
    
    switch(switchCase)
        case('specificSpectrum')
            spectrum_efficiency(data, handles);
        case('QuantumEfficiency')
            quantum_efficiency(data, handles);
        otherwise
            return;
    end
    guidata(handles.figure1, handles);
    
catch err
    if strcmp(err.identifier, 'MATLAB:indexOutOfBounds')
        disp('No data has been aqcuired, connect the analog input DAQ-card');
        
    else
        disp(strcat(err.identifier, ': ', err.message));
        rethrow(err)
    end
end
end