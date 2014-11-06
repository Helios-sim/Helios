function manRaiseOne( handles, x_cord, measured_spectrum,wanted_spectrum )
try
    handles = guidata(handles.figure1);
    %manRaiseOne allows the user to manually change the intensity for one diode at a time
    debug = getappdata(handles.figure1, 'debug_mode');
    
    if debug
       disp('In manRaiseOne'); 
    end
    
    button = 1;
    
    [wavelength, chosen_diode] = FindClickedDiode ( x_cord );
    
    %Aqcuire the maximum allowed voltages and the voltages we have now
    now_volt = getappdata(handles.figure1, 'chosen_spectrum');
    max_volt = getappdata(handles.figure1, 'max_voltage');
    
    %Deal with voltage-vectors in wavelength order
    now_volt = ChaToWave(now_volt);
    max_volt = ChaToWave(max_volt);
    
    top_y = max(measured_spectrum);
    
    %Scale the max_volt and now_volt vectors so they are about the same
    %height as the spectrum in the plot.
    scalefactor = max(measured_spectrum)/max_volt(chosen_diode);
    
    %Left-click around until you're done, but the spectrum
    %doesn't update until after right-click
    axes = handles.axes1;
    while button ~= 3
        cla;
        plot(measured_spectrum);
        plot(wanted_spectrum*scalefactor,'r');
        plot(wavelength, now_volt(chosen_diode)*scalefactor, 'k*')
        plot(wavelength, max_volt(chosen_diode)*scalefactor, 'k*')
        axis([400 1000 0 top_y*1.2])
        xlabel('Våglängd [nm]')
        ylabel('Effekt [W]')
        if(now_volt(chosen_diode) == max_volt(chosen_diode))
            power = 'Max';
            powercolor = 'r';
        else
            power = [num2str(round(now_volt(chosen_diode)/max_volt(chosen_diode)*100)) ' %'];
            powercolor = 'b';
        end
        
        % Add text
        text(wavelength + 15, now_volt(chosen_diode)*scalefactor, power, 'Color', powercolor);
        text(wavelength, max_volt(chosen_diode)*scalefactor*1.1, strcat(num2str(wavelength), 'nm'),'Color','b');
        
        [x_cord, y_cord, button] = ginputax(axes,1);
        
        if (x_cord < 0 || x_cord > 1000 || y_cord < 0 || y_cord > top_y*1.2)
            if debug
                disp(strcat('x_cord: ', num2str(x_cord)));
                disp(strcat('y_cord: ', num2str(y_cord)));
            end
            if y_cord < 0 && button ~= 3
                now_volt(chosen_diode) = 0;
                setappdata(handles.figure1, 'chosen_spectrum', now_volt);
            end
            setappdata(handles.figure1, 'clickState' ,0);
            guidata(handles.figure1, handles);
            return;
        end
        
        if (button ~= 3)
            %You cannot set the voltage above max or below zero
            if y_cord/scalefactor > max_volt(chosen_diode)
                now_volt(chosen_diode) = max_volt(chosen_diode);
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
    guidata(handles.figure1, handles);
    
catch err
    if(strcmp(err.identifier, 'MATLAB:ginput:FigureDeletionPause'))
        disp(errordlg(err.message))
    end
    rethrow(err);
end


