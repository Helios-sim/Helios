function [ daq_spanning, P ] = ImportSpectrum( textfil)
% Bra effekt, d�ligt spektrum. AM1.5 h�rdkodat tills vidare
P = [41.0777 16.5000 53.3333 43.2255 50.4000 42.7273 36.8000 48.3333 70.8000 39.0000 59.0000 49.0000 52.5000 28.5000 35.6522 50.4000];
%kompenserar f�r att inte alla dioder samarbetar f�r att uppn� �nskad
%intensitet vid en given punkt, ist�llet r�knas med de som faktiskt g�r det
samdioder = 21.8750;


%Anv�nds f�r att linjarisera f�rh�llandet mellan ljuseffekt och drivstr�m.
%med minstr�m menas den minsta drivstr�m som beh�vs f�r att dioden ska
%emittera ljus, och mineffekt �r motsvarande effekt. Dioderna t�l inte mer
%�n maxstr�m.
mineffekt = [0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  ]';
minstrom =  [0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0  ]';
%wavelength [720  980  830  590  520  490  750  660  630  780  450  420  880  945  680  515]
maxeffekt = [190  80   340  200  250  200  320  290  330  500  480  400  270  630  170  250]';
maxstrom =  [600  500  800  350  350  250  800  350  350  800  350  350  1000 1000 600  350]';

k = zeros(1,16);
for i = 1:16
    k(i) = (maxeffekt(i)-mineffekt(i))/(maxstrom(i)- minstrom(i));
end

%Vektor med effekter f�r olika dioder [mW/cm�/diod]
diod_P = P/10/samdioder;

% R�knar om ljuseffekt till styrstr�m
styrstrom = diod_P./k;

% Matrisen inneh�ller maxv�rdena fr�n de 8 f�rst�rkarkorten av kanalernas 
% f�rst�rkningsfaktorer.
forstarkningsfaktor = [62 62 100 34 34 27.5 100 34 34 100 34 34 122 122 62 34]*10^-3;

% R�knar om styrstr�m till sp�nning ut fr�n daq-kortet.
daq_spanning = styrstrom./forstarkningsfaktor;
for i = 1:16
    if daq_spanning(i) > 10
        daq_spanning(i) = 10;
    end
end

% Kontrollerar att ingen sp�nning blir f�r h�g
if failtest(daq_spanning)
    error('runtimeError:spectrumFault','the imported spectrum cannot be represented.');
end
end

