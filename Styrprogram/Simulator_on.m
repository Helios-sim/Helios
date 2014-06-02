function Simulator_on(handles)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here
try
    handles = guidata(handles.figure1);
    session = getappdata(handles.figure1,'session');
    spec_session = getappdata(handles.figure1, 'spec_session');
    appdata = getappdata(handles.figure1);
    
    chosen_spectrum = appdata.chosen_spectrum;
    
    if failtest(chosen_spectrum)
        error('runtime:spectrumFault', 'The chosen spectrum contains illegal voltage levels');
    end
    session.outputSingleScan([ones(1,16 ) 0 chosen_spectrum]);
    spec_session.outputSingleScan([chosen_spectrum(16)]);
catch
    if strcmp(err.identifier, 'runtime:spectrumFault')
        session.outputSingleScan(1,32);
        spec_session.outputSingleScan([0]);
    else
        rethrow(err);
    end
end
end

