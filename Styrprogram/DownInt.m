function [ rel_int, tmp_voltage ] = DownInt( tmp_voltage, rel_int, i, max_voltage, debug )
%UpInt makes the intensity lower by decreasing voltage to the LED that's 
%fits the spectrum worst.

%Finds the diodes within the interval 
[~, interval_diodes] = FindDiodes( rel_int, i);


%Find the diode that is furthest away from the spectrum, and by how much
[value, index] = max(interval_diodes(1,:));
diode_nr = interval_diodes(2,index);
   
if debug
    disp(['Decrease intensity of diode nr: (wavelength order) ' num2str(diode_nr)])
end

%Lets just settle with this
if value < 0.001
    value = 0;
end

%Adjusts the voltage so that it gives the wanted intensity for that diode
tmp_voltage = change_voltage(tmp_voltage, diode_nr, value, max_voltage(diode_nr));

        
%Uncheck the max-flag if a diode was lowered below max-level
if tmp_voltage(diode_nr) <= max_voltage(diode_nr)*0.9995
    rel_int(3,diode_nr) = 0;
end

end

