function DaqError(src, event)
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here
disp(src.name)
rethrow(event);
end

