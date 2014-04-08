function Voc=calculate_Voc(voltage,current)

x=min(min(abs(current)));

index_voltage=min(find(abs(current)==x));

Voc=voltage(index_voltage);