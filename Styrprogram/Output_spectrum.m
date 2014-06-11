function Output_spectrum(handles)
try
    % H�mta struktur-data
    handles = guidata(handles.figure1);
    appdata = getappdata(handles.figure1);
    session = appdata.session;
    
    length_of_step = abs(appdata.from_iv - appdata.to_iv)/appdata.step_iv;
    
    if length_of_step < 0.0012
        length_of_step = 0.0012;
    end
    
    voltage = (1/10)*[(appdata.from_iv):length_of_step:(appdata.to_iv - length_of_step)]';
    chosen_spectrum = appdata.chosen_spectrum;
    if failtest(chosen_spectrum)
        error('runtime:spectrumFault', 'The chosen spectrum contains illegal voltage levels');
    end
    spectrum = ones(1,length(voltage))'*(chosen_spectrum);
    
    %f�rbered data
    Data = [spectrum, voltage];
    
    %f�rbered DAQ-kortet f�r m�tning
    % Ge ut startsp�nning s� att inga on�diga steg g�rs i b�rjan
    session.outputSingleScan([zeros(1,15) Data(1,17)]);
    session.queueOutputData(Data);
    session.prepare;
    
    % m�tningen utf�rs
    [measure_data, timestamps, triggerTime] = session.startForeground;
    
    % st�ng av
    session.queueOutputData(zeros(1,17));
    session.prepare;
    session.startForeground;
    
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