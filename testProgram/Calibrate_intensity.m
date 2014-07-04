peak = 400;
% 139 - 1136 nm
[epw1, energy1] = intensity_load('spektrum00003.txt',peak);
[epw2, energy2] = intensity_load('spektrum00004.txt',peak);
[epw3, energy3] = intensity_load('spektrum00005.txt',peak);
[epw4, energy4] = intensity_load('spektrum00006.txt',peak);
[epw5, energy5] = intensity_load('spektrum00007.txt',peak);
[epw6, energy6] = intensity_load('spektrum00008.txt',peak);
[epw7, energy7] = intensity_load('spektrum00009.txt',peak);
[epw8, energy8] = intensity_load('spektrum00010.txt',peak);
[epw9, energy9] = intensity_load('spektrum00011.txt',peak);
[epw10, energy10] = intensity_load('spektrum00012.txt',peak);
[epw11, energy11] = intensity_load('spektrum00013.txt',peak);
[epw12, energy12] = intensity_load('spektrum00014.txt',peak);
[epw13, energy13] = intensity_load('spektrum00015.txt',peak);
[epw14, energy14] = intensity_load('spektrum00016.txt',peak);
[epw15, energy15] = intensity_load('spektrum00017.txt',peak);
%[epw16, energy16] = intensity_load('spektrum00018.txt',peak);

P = [43.2255 41.0777 16.5000 53.3333 52.5000 28.5000 35.6522 50.4000 49.0000 59.0000 39.0000 70.8000 48.3333 36.8000 42.7273 50.4000];

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

spektrum = f1+ f2+ f3+ f4+ f5+ f6 +f7 +f8 +f9 +f10+ f11+ f12+ f13+ f14 +f15+ f16;


badform_dark = load('spektrum00000.txt');
dark = badform_dark(:,1)+badform_dark(:,2)*0.01;

spectrum = (epw1 + epw2 + epw3 + epw4 + epw5 + epw6 + epw7 + epw8 + epw9 + epw10 + epw11 + epw12 + epw13 + epw14 + epw15); %+epw16
AM15_true = importdata('AM15');
AM15 = interp1(A(:,1),A(:,2),349:1136);
spectrum = interp1(dark, spectrum, 349:1136)*1e12;

length(spectrum)
length(AM15)
plot(349:1136,AM15, 349:1136, spectrum,'r', 0:1000, spektrum, 'g');