function DaqError(src, event)
%DaqError This function runs if the DAQ-card encounters an unexpected error
%   When an error is encountered the ErrorOccured event is thrown, which in
%   turn causes the listener in the main session to call this function
%   which displays the error message and throws an error to top.
disp(event.Error.getReport());
error('daqError:unexpectedRuntimeError','The Daq-device has encountered an unexpected error');
end

