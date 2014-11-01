function [ daq_spanning, P ] = ImportSpectrum( textfil)
% Bra effekt, dåligt spektrum. AM1.5 hårdkodat tills vidare
P = [41.0777 16.5000 53.3333 43.2255 50.4000 42.7273 36.8000 48.3333 70.8000 39.0000 59.0000 49.0000 52.5000 28.5000 35.6522 50.4000];
%kompenserar för att inte alla dioder samarbetar för att uppnå önskad
%intensitet vid en given punkt, istället räknas med de som faktiskt gör det
samdioder = 21.8750;


%Används för att linjarisera förhållandet mellan ljuseffekt och drivström.
%med minström menas den minsta drivström som behövs för att dioden ska
%emittera ljus, och mineffekt är motsvarande effekt. Dioderna tål inte mer
%än maxström.
mineffekt = [0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  ]';
minstrom =  [0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  ]';
%wavelength [720  980  830  590  520  490  750  660  630  780  450  420  880  945  680  515]
maxeffekt = [190  80   340  200  250  200  320  290  330  500  480  400  270  630  170  250]';
maxstrom =  [600  500  800  350  350  250  800  350  350  800  350  350  1000 1000 600  350]';

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
forstarkningsfaktor = [62 62 100 34 34 27.5 100 34 34 100 34 34 122 122 62 34]*10^-3;

% Räknar om styrström till spänning ut från daq-kortet.
daq_spanning = styrstrom./forstarkningsfaktor;
for i = 1:16
    if daq_spanning(i) > 10
        daq_spanning(i) = 10;
    end
end

% Kontrollerar att ingen spänning blir för hög
if failtest(daq_spanning)
    error('runtimeError:spectrumFault','the imported spectrum cannot be represented.');
end
end

