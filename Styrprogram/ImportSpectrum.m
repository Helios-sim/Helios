function [ daq_spanning, P ] = ImportSpectrum( textfil)
% Bra effekt, dåligt spektrum. AM1.5 hårdkodat tills vidare
P = [43.2255 41.0777 16.5000 53.3333 52.5000 28.5000 35.6522 50.4000 49.0000 59.0000 39.0000 70.8000 48.3333 36.8000 42.7273 50.4000];

%kompenserar för att inte alla dioder samarbetar för att uppnå önskad
%intensitet vid en given punkt, istället räknas med de som faktiskt gör det
samdioder = 21.8750;


%Används för att linjarisera förhållandet mellan ljuseffekt och drivström.
%med minström menas den minsta drivström som behövs för att dioden ska
%emittera ljus, och mineffekt är motsvarande effekt. Dioderna tål inte mer
%än maxström.
mineffekt = [0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0]';
minstrom = [0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0]';
maxeffekt = [200 190 80 340 270 630 170 250 400 480 500 330 290 320 200 250]';
maxstrom = [350 600 500 800 800 1000 600 350 350 350 800 350 350 800 250 350]';

k = zeros(1,16);
for i = 1:16
    k(i) = (maxeffekt(i)-mineffekt(i))/(maxstrom(i)- minstrom(i));
end

%Vektor med effekter för olika dioder [mW/cm²/diod]
diod_P = P/10/samdioder;

% Räknar om ljuseffekt till styrström
styrstrom = diod_P./k;

% Matrisen innehåller maxvärdena från de 8 förstärkarkorten av kanalernas 
% förstärkningsfaktorer.
forstarkningsfaktor = [1.74 1.76 1.81 1.75 1.77 1.74 1.75 1.79 1.76 1.76 1.74 1.75 1.74 1.75 1.74 1.75];

% Räknar om styrström till spänning ut från daq-kortet.
daq_spanning = styrstrom./forstarkningsfaktor;

% Kontrollerar att ingen spänning blir för hög
if failtest(daq_spanning)
    error('runtimeError:spectrumFault','the imported spectrum cannot be represented.');
end
end

