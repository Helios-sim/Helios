function shutdown_simulator(handles)
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here
session = getappdata(handles.figure1, 'session');
spec_session = getappdata(handles.figure1, 'spec_session');
session.outputSingleScan(zeros(1,32));
spec_session.outputSingleScan([0]);
end

