function go( channel, voltage, s, spec_s )
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here

digital = zeros(1,16);
analog = zeros(1,15);
spec_analog = 0;

digital(channel) = 1;
if(channel <16)
    analog(channel) = voltage;
else
    spec_analog = voltage;
end

% hej = failtest([analog spec_analog])

if (failtest([analog spec_analog]) == 1)

    'too high current'
    
else
s.outputSingleScan([digital analog]); spec_s.outputSingleScan([spec_analog]);

end

