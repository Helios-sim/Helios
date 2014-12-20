function [Fail] = failtest(daq_spanning)
% This function does a check on a vector with voltages to see if any
% channel will recieve too much voltages, and thereby too much current
% through the diodes.

% max_I is multiplied with 0.9 to assure that the hardware won't limit the
% current due to setting the current just a little bit too close to the
% max. If this factor of 0.9 is changed, make sure to also change the factor after "max_current" in the
% file set_up.m

forstarkningsfaktor = [62 62 100 34 34 27.5 100 34 34 100 34 34 122 122 62 34]*10^-3;
%Channel  1   2   3   4   5    6   7   8   9  10  11  12  13  14   15  16
max_I = [600 500 800 350 350 250 800 350 350 800 350 350 1000 1000 600 350]*0.9;
max_I = max_I/1000;
max_V = max_I./forstarkningsfaktor;

failvector = 0;
for i=1:16
    if daq_spanning(i)>max_V(i) || daq_spanning(i) < 0 || daq_spanning(i)>10
        failvector = failvector + 1;
        disp(['Failtest: Channel ' num2str(i) ' is too high (or below zero)'])
    end
end

if (failvector > 0)
    Fail = true;
else
    Fail = false;
end
