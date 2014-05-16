function output = testChannel(channel, voltage)
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here
output = zeros(1,31);
output(channel) = 1;
output(16 + channel) = voltage;
end

