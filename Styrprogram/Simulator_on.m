function Simulator_on(handles)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here
try
    session = getappdata(handles.figure1,'session');
    appdata = getappdata(handles.figure1);
    debug = appdata.debug_mode;
    chosen_spectrum = appdata.chosen_spectrum;
    
    if debug
        disp('simulating spectrum:');
        disp(chosen_spectrum);
    end
    
    if failtest(chosen_spectrum)
        error('runtime:spectrumFault', 'The chosen spectrum contains illegal voltage levels');
    end
    session.outputSingleScan([chosen_spectrum]);
    
catch
    shutdown_simulator(handles);
    if strcmp(err.identifier, 'runtime:spectrumFault')
        uiwait(errordlg(err.message));
        return;
    else
        rethrow(err);
    end
end
end

