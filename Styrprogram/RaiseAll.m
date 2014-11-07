function [ output_args ] = RaiseAll( handles, measured_spectrum, wanted_spectrum )

try
    handles = guidata(handles.figure1);
    
    debug = getappdata(handles.figure1, 'debug_mode');
    if debug
        disp('In RaiseAll');
    end
    
    axes = handles.axes1;
    %Aqcuire the maximum allowed voltages and the voltages we have now
    now_volt = getappdata(handles.figure1, 'chosen_spectrum');
    max_volt = getappdata(handles.figure1, 'max_voltage');
    
    if debug
        disp('before we''ve done anything: ')
        disp(['now_volt: ' num2str(now_volt)])
        disp(['max_volt: ' num2str(max_volt)])
    end
    
    %Deal with voltage-vectors in wavelength order
    max_volt = ChaToWave(max_volt);
    now_volt = ChaToWave(now_volt);
    saved_volt = now_volt;
    
    %Know where the diodes are placed
    diodeplacements = [420 450 490 590 515 520 590 630 660 680 720 750 780 830 880 945 980];
    
    
    %Keep track on the diodes that are shining with maximum strength
    maxed = zeros(1,1000);
    for i = 1:16
        if (now_volt(i) >= 0.999*max_volt(i))
            maxed(diodeplacements(i)) = 1/4;
        end
    end
    
    scale = max(wanted_spectrum)/max(max_volt./now_volt)/2;
    if debug
        disp(['scale: ' num2str(scale)]);
    end
    
    %Set color values for the buttons
    adjust_color = [0.8 0.4 1];
    backgroundcolor = [0.7 0.9 0.7];
    
    %Variable which represents the ammount of multiples of 5 percentage
    %points to change the spectrum with
    changetimes = 0;
    
    button = 2;
    while button ~= 3
        %Plot all the stuff
        cla;
        plot(measured_spectrum/max(measured_spectrum));
        plot(wanted_spectrum/max(wanted_spectrum),'r');
        plot(maxed,'r')
        xlabel('Våglängd [nm]')
        ylabel('Effekt [Arbitrary]')
        axis([400 1000 0 1.2])
        
        
        % Add text and a click function
        plusFive = text(600, 0.1,'+5 percentage points','Color', adjust_color, 'BackgroundColor',backgroundcolor);
        minusFive = text(420, 0.1,'-5 percentage points','Color', adjust_color, 'BackgroundColor',backgroundcolor);
        text(800, 0.1, strcat('+',num2str(5*changetimes),'% points'),'Color', adjust_color, 'BackgroundColor',backgroundcolor);
        
        %Let the user click in the plot to move the intensities
        [x_cord, y_cord, button] = ginputax(axes,1);
        
        if (button ~= 3)
            sE = get(plusFive,'Extent');
            cE = get(minusFive, 'Extent');
            %Check if the user clicked on the text "minus five"
            if (x_cord > cE(1) && x_cord < cE(1) + cE(3)) && (y_cord > cE(2) && y_cord < cE(2) + cE(4))
                changetimes = changetimes - 1;
                
            %Check if the user clicked on the text "plus five"
            elseif (x_cord > sE(1) && x_cord < sE(1) + sE(3)) && (y_cord > sE(2) && y_cord < sE(2) + sE(4))
                changetimes = changetimes + 1;
                
            end
            
            %Check if we went too high or too low
            for i = 1:16
                %Will any diode be maxed?
                if saved_volt(i)+max_volt(i)*changetimes*5/100 > max_volt(i)*0.999
                    now_volt(i) = max_volt(i)*0.9999;
                    maxed(diodeplacements(i)) = 1/4;
                    if debug
                        disp(['prepare to max diode: ' num2str(diodeplacements(i))]);
                    end
                    %Will any diode be set to below zero?
                elseif saved_volt(i)+max_volt(i)*changetimes*5/100 < 0
                    now_volt(i) = 0;
                    if debug
                        disp(['prepare to set diode '  num2str(diodeplacements(i)) ' to 0']);
                    end
                else
                    now_volt(i) = saved_volt(i)+max_volt(i)*changetimes*5/100;
                    maxed(diodeplacements(i)) = 0;
                    if debug
                        disp(['preparing to change diode: '  num2str(diodeplacements(i))]);
                    end
                end
            end
        end
    end
    %Change back from voltages in wavelength orders to channel orders
    now_volt = WaveToCha(now_volt);
    if debug
        disp('After RaiseAll has changed the voltages: ')
        disp(['Channel order: ' num2str(now_volt)])
    end
    
    
    
    %One extra check to see if something went wrong
    if failtest(now_volt)
        error('calibration:manual:spectrumFault', 'Raising the bar resultet in a bad spectrum')
    else
        setappdata(handles.figure1, 'chosen_spectrum', now_volt);
        guidata(handles.figure1, handles);
    end
    
    
catch err
    
    if strcmp(err.identifier,'MATLAB:ginput:FigureDeletionPause')
        if debug
            disp(['In RaiseAll. ' 'Error identifier: ' 'MATLAB:ginput:FigureDeletionPause']);
        end
    elseif strcmp(err.identifier,'MATLAB:hg:dt_conv:Matrix_to_HObject:BadHandle')
        if debug
            disp(['In RaiseAll. ' 'Error identifier: ' 'MATLAB:hg:dt_conv:Matrix_to_HObject:BadHandle']);
        end
    else
        rethrow(err);
    end
    
end









