function Output_spectrum(handles)
try
    % H�mta struktur-data
    handles = guidata(handles.figure1);
    debug = getappdata(handles.figure1, 'debug_mode');
    appdata = getappdata(handles.figure1);
    session = appdata.session;
    length_of_step = abs(appdata.from_iv - appdata.to_iv)/appdata.step_iv;
    
    if length_of_step < 0.0012
        length_of_step = 0.0012;
    end
    
    chosen_spectrum = appdata.chosen_spectrum;
    if failtest(chosen_spectrum)
        error('runtime:spectrumFault', 'The chosen spectrum contains illegal voltage levels');
    end
    spectrum = ones(1,1/length_of_step)'*(chosen_spectrum);
    
    if debug
        disp('in outputSpectrum:');
        disp(strcat('Length: ', num2str(length_of_step)));
        disp('chosen_spectrum:');
        disp(chosen_spectrum);
        disp(failtest(chosen_spectrum));
    end
    
    % f�rbered data
    Data = [spectrum];
    
    %f�rbered DAQ-kortet f�r m�tning
    session.queueOutputData(Data);
    session.prepare;
    
    % m�tningen utf�rs
    [measure_data, timestamps, triggerTime] = session.startForeground;
    
    % st�ng av
    shutdown_simulator(handles);
    
    % ber�kningar utf�rs
    process_data(measure_data, timestamps, handles);
    
    
catch err
    if strcmp(err.identifier, 'runtime:spectrumFault')
        session.outputSingleScan(1,32);
        spec_session.outputSingleScan([0]);
    else
        disp(strcat(err.identifier, ': ', err.message));
        rethrow(err);
    end
end