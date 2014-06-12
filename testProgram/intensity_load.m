function [energy_per_wavelength, energy] = intensity_load(filename,peak)

badform_measured = load(filename);
measured(:,1) = badform_measured(:,1)+badform_measured(:,2)*0.01;
measured(:,2) = badform_measured(:,3);

badform_dark = load('spektrum00000.txt');
dark(:,1) = badform_dark(:,1)+badform_dark(:,2)*0.01;
dark(:,2) = badform_dark(:,3);

fotons = (10000)*2*(measured-dark);

wavelength = badform_measured(:,1);
h = 6.626e-34;
c = 3e8;

energy_per_wavelength = (h*c./(wavelength*1e-9)).*fotons(:,2);


energy = sum(energy_per_wavelength(peak-50:peak+50));
end