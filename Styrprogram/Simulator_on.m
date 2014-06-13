function Simulator_on(handles)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here
try
    guidata(handles.figure1, handles);
    session = getappdata(handles.figure1,'session');
    appdata = getappdata(handles.figure1);
    
    chosen_spectrum = appdata.chosen_spectrum;
    
    if failtest(chosen_spectrum)
        error('runtime:spectrumFault', 'The chosen spectrum contains illegal voltage levels');
    end
    session.outputSingleScan([chosen_spectrum 0]);
catch
    if strcmp(err.identifier, 'runtime:spectrumFault')
        session.outputSingleScan(1,17);
    else
        rethrow(err);
    end
end
end

