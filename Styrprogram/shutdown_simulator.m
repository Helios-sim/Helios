function shutdown_simulator(handles)
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here
session = getappdata(handles.figure1, 'session');
session.outputSingleScan(zeros(1,17));
end

