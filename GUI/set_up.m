function set_up(hObject, handles)
try
    d = daq.getDevices;
    if isempty(d)
        error('daqError:missingDevice', 'There is no data acquisition module connected, make sure to connect your cDAQ9174 to the computer via USB');
        
    end
    guidata(handles.figure1, handles);
    
    session = daq.createSession('ni');
    spec_session = daq.createSession('ni');
    session.Rate = 25000;
    
    
    errorhandle = @DaqError;
    session.addlistener('ErrorOccurred', errorhandle);
    
    
    
    %Digital output
    session.addDigitalChannel('cDAQ1Mod2','port0/line0','OutputOnly');
    session.addDigitalChannel('cDAQ1Mod2','port0/line1','OutputOnly');
    session.addDigitalChannel('cDAQ1Mod2','port0/line2','OutputOnly');
    session.addDigitalChannel('cDAQ1Mod2','port0/line3','OutputOnly');
    session.addDigitalChannel('cDAQ1Mod2','port0/line4','OutputOnly');
    session.addDigitalChannel('cDAQ1Mod2','port0/line5','OutputOnly');
    session.addDigitalChannel('cDAQ1Mod2','port0/line6','OutputOnly');
    session.addDigitalChannel('cDAQ1Mod2','port0/line7','OutputOnly');
    session.addDigitalChannel('cDAQ1Mod2','port0/line8','OutputOnly');
    session.addDigitalChannel('cDAQ1Mod2','port0/line9','OutputOnly');
    session.addDigitalChannel('cDAQ1Mod2','port0/line10','OutputOnly');
    session.addDigitalChannel('cDAQ1Mod2','port0/line11','OutputOnly');
    session.addDigitalChannel('cDAQ1Mod2','port0/line12','OutputOnly');
    session.addDigitalChannel('cDAQ1Mod2','port0/line13','OutputOnly');
    session.addDigitalChannel('cDAQ1Mod2','port0/line14','OutputOnly');
    session.addDigitalChannel('cDAQ1Mod2','port0/line15','OutputOnly');
    
    %styrspänning över solcell för IV-mätning
    session.addAnalogOutputChannel('cDAQ1Mod1','ao15','Voltage');
    
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
    %to enable the use of the 16th analog channel to control the voltage over
    %the solar cell.
    
    spec_session.addAnalogOutputChannel('Dev2','ao0','Voltage');
    
    % Analog input
    ai0 = session.addAnalogInputChannel('cDAQ1Mod3','ai0','Voltage');
    ai1 = session.addAnalogInputChannel('cDAQ1Mod3','ai1','Voltage');
    
    %for testing purposes
    %ai2 = session.addAnalogInputChannel('cDAQ1Mod3','ai2','Voltage');
    
    ai0.TerminalConfig = 'SingleEnded';
    ai1.TerminalConfig = 'SingleEnded';
    %-----------------------
    %ai2.TerminalConfig = 'SingleEnded';
    
    session.queueOutputData([0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0]);
    spec_session.outputSingleScan([0]);
    session.prepare;
    session.startForeground;
    %setting up the rest of the user data and storing everything in the gui
    %appdata and checking if the chosen spectrum is allowed to begin with
    AM1_5 = ImportSpectrum('AM15');
    Quantum_spectrum = ImportSpectrum('AM15');
    if (failtest(AM1_5) || failtest(Quantum_spectrum))
        error('setup:spectrumFault','The chosen spectrum contains illegal voltage levels.');
    end
    
    setappdata(handles.figure1, 'session', session);
    setappdata(handles.figure1, 'spec_session', spec_session);
    setappdata(handles.figure1, 'from_iv', -2);
    setappdata(handles.figure1, 'to_iv', 5);
    setappdata(handles.figure1, 'step_iv', 16300);
    setappdata(handles.figure1, 'Jsc', 1);
    setappdata(handles.figure1, 'Voc', 1);
    setappdata(handles.figure1, 'FF', 1);
    setappdata(handles.figure1, 'eff', 0);
    setappdata(handles.figure1, 'chosen_spectrum', AM1_5);
    setappdata(handles.figure1, 'illuminated_area', 25);
    setappdata(handles.figure1, 'R', 10);
    setappdata(handles.figure1, 'Pin', 1);
    setappdata(handles.figure1, 'measurement_type', 'specificSpectrum');
    setappdata(handles.figure1, 'quantum_spectrum', Quantum_spectrum);
    
    guidata(hObject, handles);
catch err
    switch
        switchcase = err.identifier;
        case strcmp(switchcase, 'setup:spectrumFault')
            setappdata(handles.figure1, 'chosen_spectrum', zeros(1,16));
            setappdata(handles.figure1, 'quantum_spectrum', zeros(1,16));
        case strcomp(switchcase,'daqError:missingDevice')
            rethrow(err);
        case
        otherwise
    end
    
end
end



