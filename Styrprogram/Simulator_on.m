function Simulator_on(handles, hObject)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here
try
    debug = getappdata(handles.figure1, 'debug_mode');
    button_state = get(hObject, 'Value');
    session = getappdata(handles.figure1,'session');
    chosen_spectrum = getappdata(handles.figure1,'chosen_spectrum');
    filter = getappdata(handles.figure1, 'filter');
    
    if debug
        disp('button_state: ');
        disp(button_state);
        disp('simulator turning on');
        disp('simulating spectrum:');
        disp(chosen_spectrum);
        disp(filter);
    end
    
    set(hObject, 'String', 'Switch off');
    set(hObject, 'Value', get(hObject, 'Max'));
    chosen_spectrum = chosen_spectrum.*filter;
    
    if failtest(chosen_spectrum)
        error('runtime:spectrumFault', 'The chosen spectrum contains illegal voltage levels');
    end
    
    session.outputSingleScan([chosen_spectrum]);
    
catch err
    shutdown_simulator(handles);
    if strcmp(err.identifier, 'runtime:spectrumFault')
        uiwait(errordlg(err.message));
        return;
    else
        rethrow(err);
    end
end
end

