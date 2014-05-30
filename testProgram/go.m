function go( channel, voltage, s, spec_s , mode)
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here

digital = zeros(1,16);
analog = zeros(1,15);
spec_analog = 0;

if strcmp(mode, 'analogOn')
    analog = voltage*ones(1,15);
    spec_analog = voltage;
    digital(channel) = 1;
    
elseif strcmp(mode, 'digitalOn')
    if(channel <16)
        analog(channel) = voltage;
    else
        spec_analog = voltage;
    end
    digital = ones(1,16);
    
else
    if(channel <16)
        analog(channel) = voltage;
    else
        spec_analog = voltage;
    end
    digital(channel) = 1;    

end

% hej = failtest([analog spec_analog])

if (failtest([analog spec_analog]) == 1)
    disp('too high current');
    
else
    s.outputSingleScan([digital analog]); spec_s.outputSingleScan([spec_analog]);
    
end

