% Bra spektrum, dålig effekt
% P = [60.5157 61.6166/1.5 27 80/1.5 105/2 76/5 82/1.5 63/2 49 59 78/2 59 58/3 92/2.5 94/2.1 63/2];

% Bra effekt, dåligt spektrum. AM1.5 hårdkodat tills vidare
P = [43.2255 41.0777 16.5000 53.3333 52.5000 28.5000 35.6522 50.4000 49.0000 59.0000 39.0000 70.8000 48.3333 36.8000 42.7273 50.4000];

%kompenserar för att inte alla dioder samarbetar för att uppnå önskad
%intensitet vid en given punkt, istället räknas med de som faktiskt gör det
samdioder = 21.8750;

f1 = gauss_distribution(P(1),590);
f2 = gauss_distribution(P(2),720);
f3 = gauss_distribution(P(3),980);
f4 = gauss_distribution(P(4),830);
f5 = gauss_distribution(P(5),880);
f6 = gauss_distribution(P(6),945);
f7 = gauss_distribution(P(7),680);
f8 = gauss_distribution(P(8),520);
f9 = gauss_distribution(P(9),420);
f10 = gauss_distribution(P(10),450);
f11 = gauss_distribution(P(11),780);
f12 = gauss_distribution(P(12),630);
f13 = gauss_distribution(P(13),660);
f14 = gauss_distribution(P(14),750);
f15 = gauss_distribution(P(15),490);
f16 = gauss_distribution(P(16),515);

dioder = zeros(1,1001);

dioder(590)= 1;
dioder(720)= 1;
dioder(980)= 1;
dioder(830)= 1;
dioder(880)= 1;
dioder(945)= 1;
dioder(680)= 1;
dioder(520)= 1;
dioder(420)= 1;
dioder(450)= 1;
dioder(780)= 1;
dioder(630)= 1;
dioder(660)= 1;
dioder(750)= 1;
dioder(490)= 1;
dioder(515)= 1;


spektrum = f1+ f2+ f3+ f4+ f5+ f6 +f7 +f8 +f9 +f10+ f11+ f12+ f13+ f14 +f15+ f16;
A = importdata('AM15');
plot(A(:,1),A(:,2),[1:1001],spektrum, 'r',[1:1001], dioder,'g')
xlabel('Våglängd [nm]')
ylabel('Intensitet [W]')


mineffekt = [0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0]';
minstrom = [0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0]';
maxeffekt = [200 190 80 340 270 630 170 250 400 480 500 330 290 320 200 250]';
maxstrom = [350 600 500 800 800 1000 600 350 350 350 800 350 350 800 250 350]';
% Räknar om ljuseffekt till styrström
for i = 1:16
    k(i) = (maxeffekt(i)-mineffekt(i))/(maxstrom(i)- minstrom(i));
end

diod_P = P/10/samdioder;

styrstrom = diod_P./k;

forstarkningsfaktor = [1.74 1.76 1.81 1.75 1.77 1.74 1.75 1.79 1.76 1.76 1.74 1.75 1.74 1.75 1.74 1.75];

daq_spanning = styrstrom./forstarkningsfaktor;
failtest(daq_spanning)





