function [voltage current]=define_voltage_current(measurement_matrix, area)

current=measurement_matrix(:,2)/(area);

voltage=measurement_matrix(:,1);
%ta bort plotten sen
plot(voltage,current);

end