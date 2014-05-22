%kontrollera om någon spänning blir för hög från daq-kortet
function [Fail] = failtest(daq_spanning)

forstarkningsfaktor = [1.74 1.76 1.81 1.75 1.77 1.74 1.75 1.79 1.76 1.76 1.74 1.75 1.74 1.75 1.74 1.75];

max_I = [350 600 500 800 800 1000 600 350 350 350 800 350 350 800 250 350];
max_I = max_I/1000;
max_V = max_I./forstarkningsfaktor;

% failvector = 0;
% for i=1:16
%     if(daq_spanning(i)>max_V(i))
%         failvector = failvector +1;
%     end
% end
% if (failvector > 0)
%     FAIL = true
% else FAIL = false
% end
    

%Undersöker att ingen önskad spänning överstiger den maximalt tillåtna
if(isempty(nonzeros(daq_spanning>max_V)))
    fail = false
else
    fail = true
end