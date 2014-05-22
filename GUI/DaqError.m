function DaqError(src, event)
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here
disp(event.Error.getReport());
error('daqError:unexpectedRuntimeError','The Daq-device has encountered an unexpected error');
end

