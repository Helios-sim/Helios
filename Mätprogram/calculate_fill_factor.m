function FF=calculate_fill_factor(voltage,current,Jsc, Voc)

Pmax=0;

for i=1:length(current)
if(and(current(i)<0, voltage(i)<0))
Ptemp=current(i)*voltage(i);
if(Ptemp>Pmax)
    Pmax=Ptemp;
end
end
end 
FF=abs(Pmax/(Jsc*Voc));  

if(or(FF<0,FF>1))
%error('Fel, fill factor blev större än 1 eller mindre än 0');
end 
end