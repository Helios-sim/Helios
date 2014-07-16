function [M, QM] = createMatrixWave(handles)
%CREATESQUAREWAVE Summary of this function goes here
%   Detailed explanation goes here
debug = getappdata(handles.figure1,'debug_mode');
session = getappdata(handles.figure1, 'session');
rate = session.Rate;
start_frequency = 1000;
detail_level = getappdata(handles.figure1, 'detail_level');
QS = getappdata(handles.figure1, 'quantum_spectrum');
nofchannels = length(QS);

if debug
    disp('in createMatrixWave: ');
    disp(strcat('rate: ', num2str(rate)));
    disp(strcat('start frequency: ', num2str(start_frequency)));
    disp(strcat('level of detail: ', num2str(detail_level)));
    disp('quantum spectrum: ');
    disp(QS);
end
    
if detail_level > 10
    detail_level = 10;
end

length_of_data = rate*detail_level;
t = (0:(1/rate):(length_of_data - 1)/rate)';
QM = start_frequency:20:(start_frequency + 20*nofchannels);
M = zeros(length_of_data, nofchannels);

for i = 1:nofchannels
    M(:,i) = (1 + sin(2*pi*QM(i)*t))./2;
end
if debug
    disp('M:');
    disp(size(M));
end
end

