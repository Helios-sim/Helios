function [ daq_spanning, P ] = ImportSpectrum( textfil)
% Bra effekt, d�ligt spektrum. AM1.5 h�rdkodat tills vidare
P = [43.2255 41.0777 16.5000 53.3333 52.5000 28.5000 35.6522 50.4000 49.0000 59.0000 39.0000 70.8000 48.3333 36.8000 42.7273 50.4000];

%kompenserar f�r att inte alla dioder samarbetar f�r att uppn� �nskad
%intensitet vid en given punkt, ist�llet r�knas med de som faktiskt g�r det
samdioder = 21.8750;


%Anv�nds f�r att linjarisera f�rh�llandet mellan ljuseffekt och drivstr�m.
%med minstr�m menas den minsta drivstr�m som beh�vs f�r att dioden ska
%emittera ljus, och mineffekt �r motsvarande effekt. Dioderna t�l inte mer
%�n maxstr�m.
mineffekt = [0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0]';
minstrom = [0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0]';
maxeffekt = [200 190 80 340 270 630 170 250 400 480 500 330 290 320 200 250]';
maxstrom = [350 600 500 800 800 1000 600 350 350 350 800 350 350 800 250 350]';

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
forstarkningsfaktor = [1.74 1.76 1.81 1.75 1.77 1.74 1.75 1.79 1.76 1.76 1.74 1.75 1.74 1.75 1.74 1.75];

% R�knar om styrstr�m till sp�nning ut fr�n daq-kortet.
daq_spanning = styrstrom./forstarkningsfaktor;

% Kontrollerar att ingen sp�nning blir f�r h�g
if failtest(daq_spanning)
    error('runtimeError:spectrumFault','the imported spectrum cannot be represented.');
end
end

