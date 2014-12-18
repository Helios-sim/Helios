function shutdown_simulator(handles)
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here
session = getappdata(handles.figure1, 'session');
session.outputSingleScan(zeros(1,16));

% An alternative might be to use negative voltages to suppress quiescent light
% negative_spectrum = -0.003*ones(1,16);
% session.outputSingleScan(negative_spectrum);
end

