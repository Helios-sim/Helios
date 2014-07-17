function [ new_voltage ] = change_voltage( tmp_voltage, diode_nr, factor, max_voltage )

%Adjusts the voltage to a new one
tmp_voltage(diode_nr) = tmp_voltage(diode_nr)/factor;

%If we went too high, set it to maximum allowed
if tmp_voltage(diode_nr) >= max_voltage*0.9995
    tmp_voltage(diode_nr) = max_voltage*0.9995;
end

new_voltage = tmp_voltage;

end

