raw_spectrum = load('AM15', '-ascii');
vq = interp1(raw_spectrum(:,1),raw_spectrum(:,2),(380:1020))';
vq = [zeros(379,1)' vq']';


spektrumsampel = [400 500 600 700 800 900;
               500 600 700 800 900 1000]';


for n=1:6;
    integrerad_effekt = 0;
    for i=spektrumsampel(n,1):1:spektrumsampel(n,2)
        integrerad_effekt = integrerad_effekt + vq(i);
    end
    Pren(n) = integrerad_effekt;
end

 Puppmatt = Pren/10*0.8;
 
Diff1 = sum(f9 + f10 + f15)/10*0.8 - Puppmatt(1)
Diff2 = sum(f1 + f8 + f16)/10*0.8  - Puppmatt(2)
Diff3 = sum(f7 + f12 + f13)/10*0.8  - Puppmatt(3)
Diff4 = sum(f2 + f11 + f14)/10*0.8  - Puppmatt(4)
Diff5 = sum(f4 + f5)/10*0.8  - Puppmatt(5)
Diff6 = sum(f3 + f6)/10*0.8  - Puppmatt(6)
     
 

 
 