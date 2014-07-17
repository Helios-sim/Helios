function [ output_args ] = RaiseTheBar( handles )
%raiseTheBar allows the user to manually change the intensity for all the diodes at
%the same time
try
    
    
    %Aqcuire the maximum allowed voltages and the voltages we have now
    now_volt = getappdata(handles.figure1, 'chosen_spectrum');
    max_volt = getappdata(handles.figure1, 'max_voltage');
    
    %Deal with voltage-vectors in wavelength order
    max_volt = ChaToWave(max_volt);
    now_volt = ChaToWave(now_volt);
    saved_volt = now_volt;
    
    %Aqcuire the current spectrum we're using
    measured_spectrum = 
    
    %Know where the diodes are placed
    diodeplacements = [420 450 490 590 515 520 590 630 660 680 720 750 780 830 880 945 980];
    
    %Keep track on the diodes that are shining with maximum strength
    maxed = zeros(1,1000);
    for i = 1:16
        if (now_volt(i) >= 0.999*max_volt(i))
            maxed(diodeplacements(i)) = top_y/4;
        end
    end
    
    %Find k_clean. k_clean will be represented by a bar; below this bar, the
    %spectrum will be complete with no diodes maxed.
    [~, index] = max(saved_volt./max_volt);
    %If any diode already is maxed, make the clean_bar be at the same
    %height as the start_bar
    if any(maxed)
        k_clean = 1;
        
        %Otherwise find out by how much we can increase the intensity of all the
        %diodes before the first one gets maxed
        disp('k_clean = 1 because diodes were maxed from start')
    else
        k_clean = min(max_volt./now_volt);
        disp(['found k_clean: ' num2str(k_clean)])
    end
    
    %Find k_max, how far we must go to max all the diodes
    k_max = max(max_volt./now_volt);
    disp(['k_max is: ' num2str(k_max)])
    
    %Define the bars. 
    max_bar = k_max;
    clean_bar = k_clean; clean_color = [1 0 1];
    start_bar = 1; start_color = [0.8 0.4 1];
    black_bar = 0;
    
    %Scale the bars when plotting so that the max_bar is just above
    %the top of the measured spectrum.
    scale = max(measured_spectrum)/k_max*1.1;
    
    button = 2;
    
    while button ~= 3
        %Plot all the stuff
        clf;
        hold on
        plot(measured_spectrum);
        plot([400, 1000], [start_bar, start_bar]*scale, 'Color', start_color)
        plot([400, 1000], [clean_bar, clean_bar]*scale, 'Color', clean_color)
        plot([400, 1000], [max_bar, max_bar]*scale, 'r')
        plot([400, 1000], [black_bar, black_bar], 'b')
        plot(maxed,'k')
        axis([400 1000 0 top_y*1.2])
        % Add text
        text(420, start_bar*scale + start_bar*0.05,'Start', 'Color', start_color, 'BackgroundColor',[0.7 0.9 0.7]);
        text(880, clean_bar*scale + start_bar*0.05,'Rent spektrum', 'Color', clean_color, 'BackgroundColor',[0.7 0.9 0.7]);
%         text(680, max_bar*scale + start_bar*0.05, 'all max', 'Color', 'r');
        
        %Let the user click in the plot to move the intensities
        [~, y_cord, button] = ginput(1);
        
        %Black_bar should be where we click
        black_bar = y_cord;
        
        if (button ~= 3)
            if (y_cord <= 0)
                now_volt = zeros(1,16);
                maxed(diodeplacements(i)) = 0;
            else
                for i = 1:16
                    %Don't let the diodes go above their maximum ratings
                    if ( saved_volt(i)*y_cord/scale >= max_volt(i)*0.999)
                        now_volt(i) = max_volt(i)*0.9999;
                        maxed(diodeplacements(i)) = top_y/4;
                    else
                        now_volt(i) = saved_volt(i)*y_cord/scale;
                        maxed(diodeplacements(i)) = 0;
                    end
                end
            end
        end
    end
    %Change back from voltages in wavelength orders to channel orders
    now_volt = WaveToCha(now_volt);
    
    %One extra check to see if something went wrong
    if failtest(now_volt)
        error('calibration:manual:spectrumFault', 'Raising the bar resultet in a bad spectrum')
    end
    
    setappdata(handles.figure1, 'chosen_spectrum', now_volt)
    
catch err
    if(strcmp(err.identifier, 'MATLAB:ginput:FigureDeletionPause'))
        helpdlg(err.message);
        rethrow(err);
    else
        rethrow(err);
    end
end















