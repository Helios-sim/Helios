function [ powerspectrum ] = Photon_Count_To_Power( photon_count, integration_time )
%Photon_Count_To_Power Takes a spectrum (photon_count) measured by the spectrometer and
%transforms it so that the form of the spectrum changes from photon count per
%wavelength to power per wavelength.

%photon_count (the measured spectrum) must be on a specific form: 1D-vector, where the position
%of the intensity (photon count) indicates the wavelength


%Planck's constant (J*s)
h = 6.62606957*10^-34;

%Speed of light (m/s)
c = 299792458;

photon_count
integration_time

powerspectrum = zeros(1,length(photon_count));
for lambda = 1:length(photon_count)
    
    powerspectrum(lambda) = (h*c*photon_count(lambda)/(lambda*10^-9))/(integration_time*pi*0.7^2*10^-4);
       %        (E*number of photons caught)/(total integration time*area)
    
end
end



%This is how we aquired the formula that appears in the loop
    
    %     Energy_per_photon(lambda) = h*c / lambda;
    %     measured_energy(lambda) = Energy_per_photon*photon_count(lambda);
    %
    %     powerspectrum = measured_energy(lambda)/integration_time;