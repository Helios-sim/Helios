function [wavelengths , spectralData] = getSpectrum(handles)
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

%% if debug is actove, identify the spectrometer connected.
if debug
numOfSpectrometers = invoke(spectrometerObj, 'getNumberOfSpectrometersFound');
spectrometerName = invoke(spectrometerObj, 'getName', spectrometerIndex);
spectrometerSerialNumber = invoke(spectrometerObj, 'getSerialNumber', spectrometerIndex);

disp(numOfSpectrometers);
disp(spectrometerName);
disp(spectrometerSerialNumber);
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
    size(wavelengths)
    size(spectralData);
end

%% Cleanup
disconnect(spectrometerObj);
delete(spectrometerObj);

end

