function Disco(handles)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here
session = getappdata(handles.figure1, 'session');
try
rate = session.Rate;

channels = [1 8 9 10 11 12 13 15 16];

length_of_data = rate*10;
t = (0:(1/rate):(length_of_data - 1)/rate)';

removec = randi(8,1,7);

M = zeros(length_of_data, 16);
for i = 1:16
    if ismember(i, channels) && ~(ismember(i, removec))
    M(:,i) = (1 + sin(2*pi*0.5*t + rand*2*pi))./2;
    end
end
data = [0.005*M zeros(length_of_data,1)];
session.queueOutputData(data);
session.startForeground;
shutdown_simulator(handles);

catch err
    if strcmp(err.identifier, 'runtime:spectrumFault')
        disp(strcat(err.identifier, ': ', err.message));
        shutdown_simulator(handles);
    else
        disp(strcat(err.identifier, ': ', err.message));
        rethrow(err);
    end
end
end