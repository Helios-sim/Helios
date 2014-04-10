function Voc=calculate_Voc(voltage,current)

x=min(min(abs(current)));
index_voltage=find(abs(current)==x, 1 );
Voc=voltage(index_voltage);

end