function Output_spectrum(handles)
try
    % Hämta struktur-data
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
    
    %förbered data
    Data = [spectrum, voltage];
    
    %förbered DAQ-kortet för mätning
    % Ge ut startspänning så att inga onödiga steg görs i början
    session.outputSingleScan([zeros(1,15) Data(1,17)]);
    session.queueOutputData(Data);
    session.prepare;
    
    % mätningen utförs
    [measure_data, timestamps, triggerTime] = session.startForeground;
    
    % stäng av
    session.queueOutputData(zeros(1,17));
    session.prepare;
    session.startForeground;
    
    % beräkningar utförs
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