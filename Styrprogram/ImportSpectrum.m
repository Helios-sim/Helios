function [ daq_spanning ] = ImportSpectrum( textfil)
% Läser in en textfil med våglängder och ljuseffekt för ett spektrum, och
% tar fram vilka spänningar som ska skickas ut från daq_kortet för att
% simulera spektrumet. Funktionen gör en första approximation, och finjustering kommer behövas.
%   
%   Första kolonnen i matrisen kallad "egenskaper" innehåller våglängderna (nm) hos
%   de 16st dioderna, ordnad i stigande kanalordning. 
%   
%   Den 2a kolonnen innehåller drivströmmen (mA) för
%   motsvarande ljuseffekt (mW) i kolonn 3, enligt datablad. Den 2a och 3e
%   kolonnen används för att linjarisera förhållandet mellan ström och 
%   ljuseffekt. 
% 
%   Med hjälp av en fotometer kan ett mer korrekt förhållande mellan
%   drivström och ljuseffekt för dioderna utnyttjas. Ändra då på vektorn
%   "k". Vektorn k innehåller riktningskoefficienterna för
%   linjariseringen.   
%  
% 
mineffekt = [0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0]';
minstrom = [0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0]';
maxeffekt = [200 190 80 340 270 630 170 250 400 480 500 330 290 320 200 250]';
maxstrom = [350 600 500 800 800 1000 600 350 350 350 800 350 350 800 250 350]';

raw_spectrum = load(textfil, '-ascii');


%   Interpolera datan i textfilen och få den på önskad form
vq = interp1(raw_spectrum(:,1),raw_spectrum(:,2),(380:1020))';
vq = [zeros(379,1)' vq']';

% Bestämmer vilka våglängdsintervall över vilka spektrumets effekt ska integreras
spektrumsampel=[570 700 960 810 810 860 660 517 400 430 760 610 640 730 470 500;
               610 740 1000 900 900 965 700 610 439 470 850 675 680 800 517 540]';

% % Bestämmer vilka våglängdsintervall över vilka spektrumets effekt ska integreras
%  spektrumsampel=[400 430 439 470 500 517 570 610 640 660 700 730 760 810 860 960;
%                  439 470 510 517 540 610 750 675 680 700 740 800 850 900 965 1000]';
           
             
             
% P-vektorn fylls med önskad ljuseffekt för varje diod
P = zeros(16,1);
for n=1:16;
    integrerad_effekt = 0;
    for i=spektrumsampel(n,1):spektrumsampel(n,2)
        integrerad_effekt = integrerad_effekt + vq(i);
    end
    P(n) = integrerad_effekt/56*0.0896;
    if(P(n)<mineffekt(n))
        P(n) = 0;
    end
end


% Räknar om ljuseffekt till styrström
for i = 1:16
    k(i) = (maxeffekt(i)-mineffekt(i))/(maxstrom(i)- minstrom(i));
end
k = k';
styrstrom = P./k;

% for i = 1:16
%     if(styrstrom(i)<MINSTA_MÖJLIGA)
%         styrstrom(i) = 0;
%     end
% end

% Räknar om sytrströmmen till en spänning från daq-kortet
%kanalvis 1.76 1.79 1.76 1.75 1.74 1.74 1.75 1.77 1.74 1.75 1.75 1.81 1.74
%1.76 1.75 1.74
forstarkningsfaktor = [1.74 1.76 1.81 1.75 1.77 1.74 1.75 1.79 1.76 1.76 1.74 1.75 1.74 1.75 1.74 1.75]';

daq_spanning = styrstrom./forstarkningsfaktor;
daq_spanning = daq_spanning';





end

