function [M, QM] = createMatrixWave(handles)
%CREATESQUAREWAVE Summary of this function goes here
%   Detailed explanation goes here
session = getappdata(handles.figure1, 'session');
rate = session.Rate;

detail_level = getappdata(handles.figure1, 'detail_level');
QS = getappdata(handles.figure1, 'quantum_spectrum');
nofchannels = length(QS);

if detail_level > 10
    detail_level = 10;
end

length_of_data = rate*detail_level;
t = (0:(1/rate):(length_of_data - 1)/rate)';
start_frequency = 1000;
QM = start_frequency:20:(start_frequency + 20*nofchannels);
M = zeros(length_of_data, nofchannels);

for i = 1:nofchannels
    M(:,i) = (1 + sin(2*pi*QM(i)*t))./2;
end
end

