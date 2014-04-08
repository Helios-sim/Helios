function VG=calculate_efficency(FF, Jsc,Voc,Pin)

VG = (FF * abs(Jsc) * Voc )/ Pin;