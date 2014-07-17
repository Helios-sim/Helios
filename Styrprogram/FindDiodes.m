function [ free_diodes interval_diodes] = FindDiodes( rel_int, intervalnr )
%UNTITLED3 Summary of this function goes here
%   Detailed explanation goes here

%Each column represents one of the six 100 nm intervals. The first row
%tells which channel is the first one, and the second row tells us the last
%channel number within that interval.
placements = [1 4 7 10 13 15;3 6 9 12 14 16];

%Picks out the diodes within the chosen interval, including info about
% relative intensity, number of diode, and if it's maxed out
interval_diodes = rel_int(:,placements(1,intervalnr):placements(2,intervalnr));

dimensions = size(interval_diodes);


free_diodes = [];
for i = 1:dimensions(2)
    % The diodes which are not maxed are free diodes
    if(interval_diodes(3,i) == 0)
        free_diodes = [free_diodes interval_diodes(:,i)];
    end
    
end

