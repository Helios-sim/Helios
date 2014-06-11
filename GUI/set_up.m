function set_up(hObject, handles)
try
    d = daq.getDevices;
    %Check if the correct devices are installed in the correct slot
    if isempty(d)
        error('daqError:missingDevice', 'There is no data acquisition module connected, make sure to connect your cDAQ9174 to the computer via USB');
    elseif(~(strcmp(d(1).ID, 'cDAQ1Mod1') && strcmp(d(2).ID, 'cDAQ1Mod2') && strcmp(d(3).ID, 'cDAQ1Mod3')))
            error('daqError:missingDevice','You do not have the correct devices installed in the correct slot in the cDAQ device.');            
    end
    guidata(handles.figure1, handles);
    
    session = daq.createSession('ni');
    session.Rate = 25000;
    
    errorhandle = @DaqError;
    session.addlistener('ErrorOccurred', errorhandle);
    warning('off','daq:Session:implicitReleaseOccurredWarning');
   

    
    % Analog output
    session.addAnalogOutputChannel('cDAQ1Mod1','ao0','Voltage');
    session.addAnalogOutputChannel('cDAQ1Mod1','ao1','Voltage');
    session.addAnalogOutputChannel('cDAQ1Mod1','ao2','Voltage');
    session.addAnalogOutputChannel('cDAQ1Mod1','ao3','Voltage');
    session.addAnalogOutputChannel('cDAQ1Mod1','ao4','Voltage');
    session.addAnalogOutputChannel('cDAQ1Mod1','ao5','Voltage');
    session.addAnalogOutputChannel('cDAQ1Mod1','ao6','Voltage');
    session.addAnalogOutputChannel('cDAQ1Mod1','ao7','Voltage');
    session.addAnalogOutputChannel('cDAQ1Mod1','ao8','Voltage');
    session.addAnalogOutputChannel('cDAQ1Mod1','ao9','Voltage');
    session.addAnalogOutputChannel('cDAQ1Mod1','ao10','Voltage');
    session.addAnalogOutputChannel('cDAQ1Mod1','ao11','Voltage');
    session.addAnalogOutputChannel('cDAQ1Mod1','ao12','Voltage');
    session.addAnalogOutputChannel('cDAQ1Mod1','ao13','Voltage');
    session.addAnalogOutputChannel('cDAQ1Mod1','ao14','Voltage');
    session.addAnalogOutputChannel('cDAQ1Mod1','ao15','Voltage');
    
    %styrspänning över solcell för IV-mätning
    session.addAnalogOutputChannel('cDAQ1Mod2','ao0','Voltage');
    
    % Analog input
    ai0 = session.addAnalogInputChannel('cDAQ1Mod3','ai0','Voltage');
    ai1 = session.addAnalogInputChannel('cDAQ1Mod3','ai1','Voltage');
    
    ai0.TerminalConfig = 'SingleEnded';
    ai1.TerminalConfig = 'SingleEnded';
    %ai0.TerminalConfig = 'Differential';
    %ai1.TerminalConfig = 'Differential';
    
    % pulling down the output on the DAQ to make sure no leds are damaged
    session.queueOutputData(zeros(1,17));
    session.prepare;
    session.startForeground;
    
    %setting up the rest of the user data and storing everything in the gui
    %appdata and checking if the chosen spectrum is allowed to begin with
    setappdata(handles.figure1, 'session', session);
    setappdata(handles.figure1, 'from_iv', -1);
    setappdata(handles.figure1, 'to_iv', 1);
    setappdata(handles.figure1, 'step_iv', 16300);
    setappdata(handles.figure1, 'Jsc', 1);
    setappdata(handles.figure1, 'Voc', 1);
    setappdata(handles.figure1, 'FF', 1);
    setappdata(handles.figure1, 'eff', 0);
    setappdata(handles.figure1, 'illuminated_area', 25);
    setappdata(handles.figure1, 'R', 10);
    setappdata(handles.figure1, 'Pin', 1);
    setappdata(handles.figure1, 'measurement_type', 'specificSpectrum');
    setappdata(handles.figure1, 'detail_level', 1);
    setappdata(handles.figure1, 'debug_mode', 0);
    
    AM1_5 = ImportSpectrum('AM15');
    Quantum_spectrum = 0.5*ImportSpectrum('AM15');
    if (failtest(AM1_5) || failtest(Quantum_spectrum))
        error('setup:spectrumFault','The chosen spectrum contains illegal voltage levels.');
    end
    setappdata(handles.figure1, 'chosen_spectrum', AM1_5);
    setappdata(handles.figure1, 'quantum_spectrum', Quantum_spectrum);
    
    guidata(hObject, handles);
    
catch err
    switchcase = err.identifier;
    switch switchcase
        case 'setup:spectrumFault'
            disp(err.message);
            setappdata(handles.figure1, 'chosen_spectrum', zeros(1,16));
            setappdata(handles.figure1, 'quantum_spectrum', zeros(1,16));
            guidata(hObject, handles);
        case 'daqError:missingDevice'
            shutdown_simulator(handles);
            rethrow(err);
        case 'daqError:unexpectedRuntimeError'
            shutdown_simulator(handles);
            rethrow(err);
        case 'runtimeError:spectrumFault'
            disp(strcat(err.identifier, ': ', err.message));
            shutdown_simulator(handles);
            close all hidden
            rethrow(err);
        otherwise
            disp(strcat(err.identifier, ': ', err.message));
            rethrow(err);
    end
end
end



