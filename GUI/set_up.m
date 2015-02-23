function set_up(hObject, handles)
try
    %% Check if the correct devices are installed in the correct slot
    d = daq.getDevices;
    if isempty(d)
        error('daqError:missingDevice', 'There is no data acquisition module connected, make sure to connect your cDAQ9174 to the computer via USB');
    elseif(~(strcmp(d(1).ID, 'cDAQ1Mod1') && strcmp(d(2).ID, 'cDAQ1Mod2')  && strcmp(d(3).ID, 'cDAQ1Mod3')))
        error('daqError:missingDevice','You do not have the correct devices installed in the correct slot in the cDAQ device.');
    end
    guidata(handles.figure1, handles);
    
    session = daq.createSession('ni');
    session.Rate = 25000;
    
    externTrigHandle = @externTrig;
    errorhandle = @DaqError;
    session.addlistener('ErrorOccurred', errorhandle);
    warning('off','daq:Session:implicitReleaseOccurredWarning');
    
    
    %% Setting up DAQ-channels
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
    
    % secondary analog output
    
    % Analog input
    ai0 = session.addAnalogInputChannel('cDAQ1Mod3','ai0','Voltage');
    ai1 = session.addAnalogInputChannel('cDAQ1Mod3','ai1','Voltage');
    
    ai0.TerminalConfig = 'SingleEnded';
    ai1.TerminalConfig = 'SingleEnded';
    %ai0.TerminalConfig = 'Differential';
    %ai1.TerminalConfig = 'Differential';
    
    %% pulling down the output on the DAQ to make sure no leds are damaged on startup
    session.queueOutputData(zeros(1,16));
    session.prepare;
    session.startForeground;
    
    %% Parameters for setup
    detail_level = 2;
    %In channel order
    % diode wl =  [720 980 830 590 520 490 750 660 630 780 450 420 880 945 680 515]
%     If the factor 0.9 after "max_current" is changed, make sure to also
%     change the factor after "max_I" in the file failtest.m
    max_current = [600 500 800 350 350 250 800 350 350 800 350 350 1000 1000 600 350]*0.9*10^-3;
    amp_factor = [62   62  100 34  34 27.5 100 34  35  100 34  34  122 122 62  34]*10^-3;
    max_voltage = max_current./amp_factor;
    for i = 1:16
        if max_voltage(i) > 10
            max_voltage(i) = 10;
        end
    end
    
    %setting up the rest of the user data and storing everything in the gui
    %appdata and checking if the chosen spectrum is allowed to begin with
    setappdata(handles.figure1, 'session', session);
    setappdata(handles.figure1, 'measurement_type', 'specificSpectrum');
    setappdata(handles.figure1, 'detail_level', detail_level);
    setappdata(handles.figure1, 'debug_mode', false);
    setappdata(handles.figure1, 'spectrum_integration_time', 100000*detail_level);
    setappdata(handles.figure1, 'max_current', max_current);
    setappdata(handles.figure1, 'amp_factor', amp_factor);
    setappdata(handles.figure1, 'max_voltage', max_voltage);
    setappdata(handles.figure1, 'clickState', -1);
    setappdata(handles.figure1, 'measured_spectrum', []);
    setappdata(handles.figure1, 'filter', ones(1,16));
    setappdata(handles.figure1, 'spectCon', false);
    
    wanted_spectrum = ImportRawSpectrum('SparadeSpektrum/AM15.spec');
    setappdata(handles.figure1, 'wanted_spectrum', wanted_spectrum*0.9);
    
    AM1_5 = 0.9*[8.60808459859326 6.84331797235023 5.16302198319328 9 8.53835294117647 7.99056000000000 3.78514285714286 7.05881866125761 9 2.56731428571429 5.20588235294118 5.18823529411765 6.55737704918033 1.52559384409502 8.35009509352128 8.53835294117647];
       
%     start_spectrum = zeros(1,16);
%     negative_spectrum = -0.003*ones(1,16);%to suppress quiescent light
%     start_spectrum = negative_spectrum
    
    start_spectrum = AM1_5;
    
    Quantum_spectrum = zeros(1,16);
    if (failtest(start_spectrum) || failtest(Quantum_spectrum))
        error('setup:spectrumFault','The chosen spectrum contains illegal voltage levels.');
    end
    
    
    setappdata(handles.figure1,'chosen_spectrum',start_spectrum);
    
    setappdata(handles.figure1, 'quantum_spectrum', Quantum_spectrum);
    
    guidata(hObject, handles);
    
    
    %% Make sure nothing goes wrong, and if it does, make sure that no LEDs come to harm
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
