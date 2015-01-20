function spectrumdata = getSpectrum(handles)
try
    %getSpectrum aqcuires a spectral scan from the connected spectrometer if
    %one is connected
    
    %% Connect to the instrument.
    
    spectrometerObj = icdevice('OceanOptics_OmniDriver.mdd');
    
    connect(spectrometerObj);
    
    %% Set parameters for spectrum acquisition.
    integrationTime = getappdata(handles.figure1, 'spectrum_integration_time');
    spectrometerIndex = 0;
    channelIndex = 0;
    enable = 1;
    debug = getappdata(handles.figure1, 'debug_mode');
    
    
    %% if debug is active, identify the spectrometer connected.
    
    if debug
        disp('in getSpectrum');
        numOfSpectrometers = invoke(spectrometerObj, 'getNumberOfSpectrometersFound');
        spectrometerName = invoke(spectrometerObj, 'getName', spectrometerIndex);
        spectrometerSerialNumber = invoke(spectrometerObj, 'getSerialNumber', spectrometerIndex);
        minIntTime = invoke(spectrometerObj, 'getMinimumIntegrationTime', spectrometerIndex);
        
        disp(['minIntTime: ' num2str(minIntTime)]);
        disp(['spectrometer name: ' spectrometerName]);
        disp(['spectrometer name: ' spectrometerSerialNumber]);
        disp(strcat('IntegrationTime: ', num2str(integrationTime)));
        disp(strcat('spectrometerIndex: ', num2str(spectrometerIndex)));
        disp(strcat('channelIndex: ', num2str(channelIndex)));
        disp(strcat('enable: ', num2str(enable)));
        
    end
    
    %% Set the parameters for spectrum acquisition.
    invoke(spectrometerObj, 'setIntegrationTime', spectrometerIndex, channelIndex, integrationTime);
    invoke(spectrometerObj, 'setCorrectForDetectorNonlinearity', spectrometerIndex, channelIndex, enable);
    invoke(spectrometerObj, 'setCorrectForElectricalDark', spectrometerIndex, channelIndex, enable);
    
    %% Aquire the spectrum.
    wavelengths = invoke(spectrometerObj, 'getWavelengths', spectrometerIndex, channelIndex);
    % Get the wavelengths and save them in a double array.
    spectralData = invoke(spectrometerObj, 'getSpectrum', spectrometerIndex);
    
    if debug
        disp('Wavelengths: ');
        disp(size(wavelengths));
        disp('spectralData: ');
        disp(size(spectralData));
    end
    %% Adjust the spectrum to the form we want to work with
    measured_spectrum = interp1(wavelengths, spectralData, (400:1000));
    spectrumdata = [zeros(1,399) measured_spectrum];
    
    %When the spectrometer aquires a spectrum, there will be unwanted photons
    %approximately evenly distributed across the interval. This step is to
    %reduce the photon-noise.
%     [~, peakindex] = max(spectrumdata);
%     peakindex = round(peakindex);
%     if peakindex > 720
%         average = mean(round(spectrumdata(400:peakindex-100)));
%     else
%         average = mean(round(spectrumdata(peakindex+100:1000)));
%     end
%     spectrumdata = spectrumdata - average;
%     spectrumdata(1:peakindex-100) = 0;
%     spectrumdata(peakindex+100:1000) = 0;
%     negatives = spectrumdata<0;
%     spectrumdata(negatives) = 0;
    
    %We've got photons vs wavelength, but we want power vs wavelength.
    %IntegrationTime is measured in microseconds
    spectrumdata = Photon_Count_To_Power(spectrumdata, integrationTime*10^-6);
    
    setappdata(handles.figure1,'spectCon',true);
    
    %% Cleanup
    disconnect(spectrometerObj);
    delete(spectrometerObj);
    
    
    %%
catch err
    debug = getappdata(handles.figure1, 'debug_mode');
    if debug
        disp('in getSpectrum, and we have recieved an error');
    end
    
    if strcmp(err.identifier, 'instrument:connect:opfailed')
        
        spectrumdata = zeros(1,1000);
        setappdata(handles.figure1,'spectCon',false);
        return;
    else
        rethrow(err);
        
    end
    
end


