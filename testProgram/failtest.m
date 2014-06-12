%kontrollera om n�gon sp�nning blir f�r h�g fr�n daq-kortet
function [Fail] = failtest(daq_spanning)

forstarkningsfaktor = [1.74 1.76 1.81 1.75 1.77 1.74 1.75 1.79 1.76 1.76 1.74 1.75 1.74 1.75 1.74 1.75];
%Kanal     1   2   3   4   5    6   7   8   9  10  11  12  13  14  15  16
max_I = [350 600 500 800 800 1000 600 350 350 350 800 350 350 800 250 350];
max_I = max_I/1000;
max_V = max_I./forstarkningsfaktor;

failvector = 0;
for i=1:16
    if(daq_spanning(i)>max_V(i))
        failvector = failvector +1;
        i
    end
end
if (failvector > 0)
    Fail = true;
else
    Fail = false;
end


%Unders�ker att ingen �nskad sp�nning �verstiger den maximalt till�tna
% if(isempty(nonzeros(daq_spanning>max_V)))
%     Fail = false;
% else
%     Fail = true;
% end