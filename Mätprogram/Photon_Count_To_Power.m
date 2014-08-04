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

powerspectrum = zeros(1,length(photon_count));
for i = 1:length(photon_count)
    
    powerspectrum(i) = h*c/i*photon_count(i)*integration_time;
    
end
end

%This is what happens in the loop, step by step
    
    %     Energy_per_photon(i) = h*c / i;
    %     measured_energy(i) = Energy_per_photon*measured_spectrum(i);
    %
    %     powerspectrum = measured_energy(i)*integration_time;