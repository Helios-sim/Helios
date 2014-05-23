function [ daq_spanning ] = ImportSpectrum( textfil)
% L�ser in en textfil med v�gl�ngder och ljuseffekt f�r ett spektrum, och
% tar fram vilka sp�nningar som ska skickas ut fr�n daq_kortet f�r att
% simulera spektrumet. Funktionen g�r en f�rsta approximation, och finjustering kommer beh�vas.
%   
%   F�rsta kolonnen i matrisen kallad "egenskaper" inneh�ller v�gl�ngderna (nm) hos
%   de 16st dioderna, ordnad i stigande kanalordning. 
%   
%   Den 2a kolonnen inneh�ller drivstr�mmen (mA) f�r
%   motsvarande ljuseffekt (mW) i kolonn 3, enligt datablad. Den 2a och 3e
%   kolonnen anv�nds f�r att linjarisera f�rh�llandet mellan str�m och 
%   ljuseffekt. 
% 
%   Med hj�lp av en fotometer kan ett mer korrekt f�rh�llande mellan
%   drivstr�m och ljuseffekt f�r dioderna utnyttjas. �ndra d� p� vektorn
%   "k". Vektorn k inneh�ller riktningskoefficienterna f�r
%   linjariseringen.   
%  
% 
mineffekt = [0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0]';
minstrom = [0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0]';
maxeffekt = [200 190 80 340 270 630 170 250 400 480 500 330 290 320 200 250]';
maxstrom = [350 600 500 800 800 1000 600 350 350 350 800 350 350 800 250 350]';

raw_spectrum = load(textfil, '-ascii');


%   Interpolera datan i textfilen och f� den p� �nskad form
vq = interp1(raw_spectrum(:,1),raw_spectrum(:,2),(380:1020))';
vq = [zeros(379,1)' vq']';

% figure(1)
% plot(vq)
% figure(2)
% plot(raw_spectrum(:,1),raw_spectrum(:,2))
% axis([0 1200 0 1.8]);

% Best�mmer vilka v�gl�ngdsintervall �ver vilka spektrumets effekt ska integreras
%               590 720 980 830 880 945 680 520 420 450 780 630 660 750 490 515
%               d   d       d   d   d   d               d   d       d   d   d
spektrumsampel=[570 690 960 790 810 860 650 500 400 430 730 610 640 700 470 500;
               610 740 1000 870 930 975 710 540 440 470 800 650 680 780 530 540]';

% % Best�mmer vilka v�gl�ngdsintervall �ver vilka spektrumets effekt ska integreras
%  spektrumsampel=[400 430 439 470 500 517 570 610 640 660 700 730 760 810 860 960;
%                  439 470 510 517 540 610 750 675 680 700 740 800 850 900 965 1000]';
           
             
             
% P-vektorn fylls med �nskad ljuseffekt f�r varje diod
P = zeros(16,1);
for n=1:16;
    integrerad_effekt = 0;
    for i=spektrumsampel(n,1):1:spektrumsampel(n,2)
        integrerad_effekt = integrerad_effekt + vq(i);
    end
    P(n) = integrerad_effekt/56*0.0896;
    if(P(n)<mineffekt(n))
        P(n) = 0;
    end
end


% R�knar om ljuseffekt till styrstr�m
for i = 1:16
    k(i) = (maxeffekt(i)-mineffekt(i))/(maxstrom(i)- minstrom(i));
end
k = k';
styrstrom = P./k;

% for i = 1:16
%     if(styrstrom(i)<MINSTA_M�JLIGA)
%         styrstrom(i) = 0;
%     end
% end

% R�knar om sytrstr�mmen till en sp�nning fr�n daq-kortet
%kanalvis 1.76 1.79 1.76 1.75 1.74 1.74 1.75 1.77 1.74 1.75 1.75 1.81 1.74
%1.76 1.75 1.74
forstarkningsfaktor = [1.74 1.76 1.81 1.75 1.77 1.74 1.75 1.79 1.76 1.76 1.74 1.75 1.74 1.75 1.74 1.75]';

daq_spanning = styrstrom./forstarkningsfaktor;
daq_spanning = daq_spanning';





end

