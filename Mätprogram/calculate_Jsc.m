function Jsc=calculate_Jsc(voltage, current)

x=min(min(abs(voltage)));
index_current=find(abs(voltage)==x,1);
Jsc=current(index_current);

end
