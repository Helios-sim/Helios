function [ daq_spanning ] = ImportSpectrum( textfil)
% Läser in en textfil med våglängder och ljuseffekt för ett spektrum, och
% tar fram vilka spänningar som ska skickas ut från daq_kortet för att
% simulera spektrumet. Funktionen gör en första approximation, och finjustering kommer behövas.
%   
%   Första kolonnen i matrisen kallad "egenskaper" innehåller våglängderna (nm) hos
%   de 16st dioderna. 
%   
%   Den 2a innehåller drivströmmen (mA) för
%   motsvarande ljuseffekt (mW) i kolonn 3, enligt datablad. Den 2a och 3e
%   kolonnen används för att linjarisera förhållandet mellan ström och 
%   ljuseffekt. 
% 
%   Med en fotometer kan ett mer korrekt förhållande mellan
%   drivström och ljuseffekt för dioderna användas. Ändra då på vektorn
%   "k". Vektorn k innehåller riktningskoefficienterna för
%   linjariseringen.   
%  
% 
egenskaper = [420 450 490 515 520 590 630 660 680 720 750 780 830 880 945 980;
              350 350 250 350 350 350 350 350 600 600 800 800 800 800 1000 500;
              400 480 200 250 250 200 330 290 170 190 320 500 340 270 630 80]';

raw_spectrum = load(textfil, '-ascii');


%   Interpolera datan i textfilen och få den på önskad form
vq = interp1(raw_spectrum(:,1),raw_spectrum(:,2),(380:1020))';
vq = [zeros(379,1)' vq']';


% Bestämmer vilka våglängdsintervall över vilka spektrumets effekt ska integreras
 spektrumsampel=[400 430 439 470 500 517 570 610 640 660 700 730 760 810 860 960;
                 439 470 510 517 540 610 750 675 680 700 740 800 850 900 965 1000]';
           
             
             
% P-vektorn fylls med önskad ljuseffekt för varje diod
P = zeros(16,1);
for n=1:16;
    integrerad_effekt = 0;
    for i=spektrumsampel(n,1):spektrumsampel(n,2)
        integrerad_effekt = integrerad_effekt + vq(i);
    end
    P(n) = integrerad_effekt/56*0.0896;
end


% Räknar om ljuseffekt till styrström
for i = 1:16
    k(i) = egenskaper(i,3)/egenskaper(i,2);
end
k = k';
styrstrom = P./k;

% Räknar om sytrströmmen till en spänning från daq-kortet
%kanalvis 1.76 1.79 1.76 1.75 1.74 1.74 1.75 1.77 1.74 1.75 1.75 1.81 1.74
%1.76 1.75 1.74
forstarkningsfaktor = [1.74 1.76 1.81 1.75 1.77 1.74 1.75 1.79 1.76 1.76 1.74 1.75 1.74 1.75 1.74 1.75]';

daq_spanning = styrstrom./forstarkningsfaktor;
daq_spanning = daq_spanning';





end

