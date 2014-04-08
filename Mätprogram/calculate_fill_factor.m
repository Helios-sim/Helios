function FF=calculate_fill_factor(voltage,current)

max=zeros(length(current));
for i=1:length(current)
if(and(current(i)<0, voltage(i)<0))
max(i)=current(i)*voltage(i);
end
end

Pmax=min(min(max)); 
FF=abs(Pmax/(Jsc*Voc));  

if(FF>1)
error('Fel, fill factor blev större än 1');
FF=NaN;
end 