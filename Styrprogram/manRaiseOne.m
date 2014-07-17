function manRaiseOne( handles, x_cord )

%manRaiseOne allows the user to manually change the intensity for one diode at a time

button = 1;

[wavelength, chosen_diode] = FindClickedDiode ( x_cord );

%Aqcuire the maximum allowed voltages and the voltages we have now
now_volt = getappdata(handles.figure1, 'chosen_spectrum');
max_volt = getappdata(handles.figure1, 'max_voltage');

%Deal with voltage-vectors in wavelength order
now_volt = ChaToWave(now_volt);
max_volt = ChaToWave(max_volt);

measured_spectrum =

%Scale the max_volt and now_volt vectors so they are about the same
%height as the spectrum in the plot.
scalefactor = max(measured_spectrum)/max_volt(chosen_diode);

%Left-click around until you're done, but the spectrum
%doesn't update until after right-click
while button ~= 3
    
    clf;
    hold on
    plot(measured_spectrum)
    plot(wavelength, now_volt(chosen_diode)*scalefactor, 'k*')
    plot(wavelength, max_volt(chosen_diode)*scalefactor, 'k*')
    axis([400 1000 0 top_y*1.2])
    
    if(now_volt(chosen_diode) == max_volt(chosen_diode))
        power = 'Max';
        powercolor = 'r';
    else
        power = [num2str(round(now_volt(chosen_diode)/max_volt(chosen_diode)*100)) ' %'];
        powercolor = 'b';
    end
    
    % Add text
    text(wavelength + 15, now_volt(chosen_diode)*scalefactor, power, 'Color', powercolor);
    
    [~, y_cord, button] = ginput(1);
    
    if (button ~= 3)
        %You cannot set the voltage above max or below zero
        if y_cord/scalefactor > max_volt(chosen_diode)
            now_volt(chosen_diode) = max_volt(chosen_diode);
        elseif y_cord < 0
            now_volt(chosen_diode) = 0;
        else
            now_volt(chosen_diode) = y_cord/scalefactor;
        end
    end
end

%Change back from voltages in wavelength orders to channel orders
now_volt = WaveToCha(now_volt);

if failtest(now_volt)
    error('calibration:manual:spectrumFault', 'Manual adjustment resultet in a bad spectrum')
end

%Establish the new voltages
setappdata(handles.figure1, 'chosen_spectrum', now_volt);


