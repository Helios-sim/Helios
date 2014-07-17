function [ wavelength, chosen_diode ] = FindClickedDiode( x_cord )
%FindClickedDiode is used in the GUI by the user to select one of the
%diodes by clicking the plot. It returns the diode number in wavelength
%order. Diode 1 is 420 nm, 2 is 450, 3 is 490 and so on...



diode_placements = [420 450 490 515 520 590 630 660 680 720 750 780 830 880 945 980];

[~, chosen_diode] = min(abs(diode_placements - x_cord));

wavelength = diode_placements(chosen_diode);



end

