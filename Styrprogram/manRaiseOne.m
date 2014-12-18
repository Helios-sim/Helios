function manRaiseOne( handles, x_cord, measured_spectrum,wanted_spectrum )
%manRaiseOne allows the user to manually change the intensity for one diode at a time

try
    handles = guidata(handles.figure1);
    debug = getappdata(handles.figure1, 'debug_mode');
    if debug
        disp('In manRaiseOne');
    end
    
    %Find the diode which has been selected by the user
    [wavelength, chosen_diode] = FindClickedDiode ( x_cord );
    
    %Acquire the maximum allowed voltages and the voltages we have now
    now_volt = getappdata(handles.figure1, 'chosen_spectrum');
    max_volt = getappdata(handles.figure1, 'max_voltage');
    
    %Deal with voltage-vectors in wavelength order
    now_volt = ChaToWave(now_volt);
    max_volt = ChaToWave(max_volt);
    
    %Used for the plot in the first iteration of the loop. Later, in the while loop below, the y_cord
    %will be decided by using the mouses left button
    y_cord = now_volt(chosen_diode)/max_volt(chosen_diode);
    
    axes = handles.axes1;
    
    button = 1;
    %Left-click around until you're done, but the spectrum
    %doesn't update until after right-click
    while button ~= 3
        
        %Set the text string and position
        if(now_volt(chosen_diode) == max_volt(chosen_diode))
            power = 'Max';
            powercolor = 'r';
            text_cord = 1;
        else
            power = [num2str(round(y_cord*100)) ' %'];
            powercolor = 'b';
            text_cord = y_cord;
        end
        
        cla;
        %The top will be at 1 for both the measured and the wanted spectrums
        plot(measured_spectrum/max(measured_spectrum));
        plot(wanted_spectrum/max(wanted_spectrum),'r');
        plot(wavelength, 1, 'k*')
        plot(wavelength, text_cord, 'k*')
        axis([400 1000 0 1.2])
        xlabel('Wavelength [nm]')
        ylabel('Power [Arbitrary]')
        
        % Add text
        text(wavelength + 15, text_cord, power, 'Color', powercolor);
        text(wavelength, 1.15, strcat(num2str(wavelength), 'nm'),'Color','b');
        
        [x_cord, y_cord, button] = ginputax(axes,1);
        if debug
            disp(strcat('x_cord: ', num2str(x_cord)));
            disp(strcat('y_cord: ', num2str(y_cord)));
        end
        if (x_cord < 0 || x_cord > 1000 || y_cord < 0 || y_cord > 1.2)
            if debug
                disp('click was outside the image')
            end
            setappdata(handles.figure1, 'clickState' ,0);
            guidata(handles.figure1, handles);
            return;
        end
        
        if (button == 3)
            %You cannot set the voltage above max or below zero
            if y_cord > 1
                if debug
                    disp('trying to set diode above max')
                end
                now_volt(chosen_diode) = max_volt(chosen_diode);
            else
                now_volt(chosen_diode) = y_cord*max_volt(chosen_diode);
            end
        end
    end
    
    %Change back from voltages in wavelength orders to channel orders
    now_volt = WaveToCha(now_volt);
    
    if failtest(now_volt)
        error('calibration:manual:spectrumFault', 'Manual adjustment resultet in a bad spectrum')
    else
        %Establish the new voltages
        setappdata(handles.figure1, 'chosen_spectrum', now_volt);
        guidata(handles.figure1, handles);
    end
   
    
catch err
    if(strcmp(err.identifier, 'MATLAB:ginput:FigureDeletionPause'))
        disp(errordlg(err.message))
    end
    rethrow(err);
end

