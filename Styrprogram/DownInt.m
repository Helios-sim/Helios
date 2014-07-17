function [ rel_int, tmp_voltage ] = DownInt( tmp_voltage, rel_int, i, max_voltage )
%UpInt makes the intensity lower by decreasing voltage to the LED that's 
%fits the spectrum worst.

%Finds the diodes within the interval that the are furthest away from the spectrum, 
%and by how much
[~, interval_diodes] = FindDiodes( rel_int, i);
[value, index] = max(interval_diodes(1,:));
diode_nr = interval_diodes(2,index);
        
%Adjusts the voltage so that it gives the wanted intensity for that diode
tmp_voltage = change_voltage(tmp_voltage, diode_nr, value, max_voltage(diode_nr));

        
%Uncheck the max-flag if a diode was lowered below max-level
if tmp_voltage(diode_nr) <= max_voltage(diode_nr)
    rel_int(3,diode_nr) = 0;
end

end

