function eff=calculate_efficiency(FF, Jsc,Voc,Pin)

eff = abs((FF *Jsc * Voc )/ Pin);

end