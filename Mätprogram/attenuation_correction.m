clear;close all;
attenuation = [zeros(1,5) ones(1,7) 2 2 3 3 3 3 4 4 6 6 6 6 6];
subplot(222)
plot(attenuation)
title('attenuation (db)')

measures = ones(1,25);
subplot(221)
plot(measures)
title('measures')

if length(measures) > length(attenuation)
    attenuation = [attenuation zeros(1,length(measures)-length(attenuation))];
end
        
real = length(measures);
for i = 1:length(measures);
    real(i) = measures(i)/10^(-attenuation(i)/10);
end

subplot(223)
plot(real)
title('corrected')