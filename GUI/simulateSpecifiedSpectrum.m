function spectrum = simulateSpecifiedSpectrum(filename)
importdata(filename);
peak_emissions = [420 450 490 515 520 590 630 660 680 720 750 780 830 880 945 980];
spectrum = spline(1:length(measurement), measurement, peak_emissions);
end
