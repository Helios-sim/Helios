function [voltage current]=define_voltage_current(filename, area)

measurement_matrix=daqread('filename');

for i=1:length(measurment_matrix)
measurement_matrix(i,2)= measurement_matrix(i,2)/(R*area);
end 

current=zeros(length(sample_matrix));

for i=1:length(measurement_matrix)
    current(i)=measurement_matrix(i,2);
end

voltage=zeros(length(measurement_matrix));

for i=1:length(measurement_matrix)
    voltage(i)=measurement_matrix(i,1);
end

plot(voltage,current);

end