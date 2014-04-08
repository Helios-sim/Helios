function Jsc=calculate_Jsc(voltage, current)

x=min(min(abs(voltage)));

index_current=find(abs(voltage)==x);
Jsc=current(index_current);

