function [faktor, maxFak] = ampTest(values)
faktor = 0;
maxFak = 0;
for i = 1:6
    faktor = faktor + values(i)/(100*i);
    if maxFak < values(i)/(100*i)
        maxFak = values(i)/(100*i);
    end
end

%Medelfaktor
faktor = faktor/6;

%Högströmsfaktor
% [Y, I] = max(values)
% maxFak = Y/(I*100);