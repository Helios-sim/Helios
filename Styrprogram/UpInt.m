function [ tight, rel_int, tmp_voltage ] = UpInt( tmp_voltage, rel_int, i, max_voltage, Ihave, Iwant, debug )
%UNTITLED3 Summary of this function goes here
%   Detailed explanation goes here

%Find the diodes withing the interval and don't look at the maxed out diodes, only look at those who are
%free to go higher
[free_diodes, ~] = FindDiodes(rel_int, i);
        

%Check if there are any diodes which can be raised
if not(isempty(free_diodes))
    
    
    %If we're close to following the spectrum but the intensity is not
    %enough, then increase all the diodes at the same time    
    if (0.9 < max(free_diodes(1,:)) &&  max(free_diodes(1,:)) < 1.1);
        if debug
            disp('Increase intensity of multiple diodes at the same time')
        end
        %If it's 20% off, then make all the diodes shine 20% brighter
        scaleup = Ihave(i)./Iwant(i);
        diode_nr = free_diodes(2,:);
        for n = 1:length(diode_nr)
            tmp_voltage = change_voltage(tmp_voltage, diode_nr(n), scaleup, max_voltage(diode_nr(n)));
        end
        
    else
        %Finds the diode which has the worst intensity, and by how much it is off
        [value, index] = min(free_diodes(1,:));
        diode_nr = free_diodes(2,index);
        
        if debug
            disp(['Increase intensity of diode nr: (wavelength order)' num2str(diode_nr)])
        end
                
        %Adjusts the voltage so that it gives the wanted intensity for that diode
        tmp_voltage = change_voltage(tmp_voltage, diode_nr, value, max_voltage(diode_nr));
             
    end
    
    %We did adjustments, so we're not sure that we're following the
    %spectrum tightly
    tight = false;
else
    
    %If we didn't change the voltage, we're following the spectrum tightly
    tight = true;
       
end

end


