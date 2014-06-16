function go( channel, voltage, s , mode)
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here
try
analog = zeros(1,16);

% sätt kanal
if strcmp(mode, 'spectrum')
    analog = voltage; 
else
    analog(channel) = voltage(channel);
end

% kolla om korrekt spektrum och skicka ut
if (failtest(analog) == 1)
    disp('too high current');
else
    s.outputSingleScan(analog);
end

catch err
    disp(err.message)
    s.outputSingleScan(zeros(1,16));
end

