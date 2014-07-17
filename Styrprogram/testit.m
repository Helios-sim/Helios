
clickState = 1;
while (clickState == 1)
    
    
    addpath('H:\TFYA75\mjukvara')
    addpath('H:\TFYA75\mjukvara\TestProgram')
    raw_spectrum_wanted = load('AM15');
    measured_spectrum = interp1(raw_spectrum_wanted(:,1),raw_spectrum_wanted(:,2),(400:1000))';
    measured_spectrum = [zeros(1,399) measured_spectrum']';
    
    top_y = max(measured_spectrum);
    ydiodes(420) = top_y/4;
    ydiodes(450) = top_y/4;
    ydiodes(490) = top_y/4;
    ydiodes(515) = top_y/4;
    ydiodes(520) = top_y/4;
    ydiodes(590) = top_y/4;
    ydiodes(630) = top_y/4;
    ydiodes(660) = top_y/4;
    ydiodes(680) = top_y/4;
    ydiodes(720) = top_y/4;
    ydiodes(750) = top_y/4;
    ydiodes(780) = top_y/4;
    ydiodes(830) = top_y/4;
    ydiodes(880) = top_y/4;
    ydiodes(945) = top_y/4;
    ydiodes(980) = top_y/4;
    
    % Showing the diode spikes, left or right-click to proceed and right
    % click to go back
    clf;
    hold on
    plot(ydiodes, 'k');
    plot(measured_spectrum)
    axis([400 1000 0 top_y*1.2])
    
    [x_cord, ~, button] = ginput(1);
    
    if button == 1
        
        [wavelength, chosen_diode] = FindClickedDiode ( x_cord );
        %Playing around with some values here just for testing
        forstarkningsfaktor = [1.74 1.76 1.81 1.75 1.77 1.74 1.75 1.79 1.76 1.76 1.74 1.75 1.74 1.75 1.74 1.75];
        max_I = [350 600 500 800 1000 1000 600 350 350 350 800 350 350 800 250 350];
        max_I = max_I/1000;
        max_V = max_I./forstarkningsfaktor;
        max_volt = ChaToWave(max_V);
        now_volt = max_volt*0.6;
        now_volt(1) = now_volt(1)*1.5;
        now_volt(2) = now_volt(2)*1.4;
        now_volt(3) = now_volt(3)*1.3;
        now_volt(4) = now_volt(4)*1.2;
        now_volt(5) = now_volt(5)*1.1;
        now_volt(6) = now_volt(6)*1;
        now_volt(7) = now_volt(7)*0.9;
        now_volt(8) = now_volt(8)*0.8;
        now_volt(9) = now_volt(9)*0.7;
        now_volt(10) = now_volt(12)*0.6;
        
        %Scale the max_volt and now_volt vectors so they are about the same
        %height as the spectrum in the plot.
        scalefactor = max(measured_spectrum)/max_volt(chosen_diode);
        
        %Left-click around until you're done, but the spectrum
        %doesn't update until after right-click
        while button ~= 3
            
            clf;
            hold on
            plot(measured_spectrum)
            plot(wavelength, now_volt(chosen_diode)*scalefactor, 'b*')
            plot(wavelength, max_volt(chosen_diode)*scalefactor, 'r*')
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
        
        
    elseif button == 2
        %Playing around with some values here just for testing
        forstarkningsfaktor = [1.74 1.76 1.81 1.75 1.77 1.74 1.75 1.79 1.76 1.76 1.74 1.75 1.74 1.75 1.74 1.75];
        max_I = [350 600 500 800 1000 1000 600 350 350 350 800 350 350 800 250 350];
        max_I = max_I/1000;
        max_V = max_I./forstarkningsfaktor;
        max_volt = ChaToWave(max_V);
        now_volt = max_volt*0.6;
        now_volt(1) = now_volt(1)*1.5;
        now_volt(2) = now_volt(2)*1.4;
        now_volt(3) = now_volt(3)*1.3;
        now_volt(4) = now_volt(4)*1.2;
        now_volt(5) = now_volt(5)*1.1;
        now_volt(6) = now_volt(6)*1;
        now_volt(7) = now_volt(7)*0.9;
        now_volt(8) = now_volt(8)*0.8;
        now_volt(9) = now_volt(9)*0.7;
        now_volt(10) = now_volt(12)*0.6;
        saved_volt = now_volt;
        
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
        else
            k_clean = min(max_volt./now_volt);
        end
        
        %Find k_max, how far we must go to max all the diodes
        k_max = max(max_volt./now_volt);
        
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
            plot([400, 1000], [black_bar, black_bar], 'k')
            plot(maxed,'r')
            axis([400 1000 0 top_y*1.2])
            % Add text
            text(420, start_bar*scale + start_bar*0.05,'start', 'Color', start_color, 'BackgroundColor',[0.5 0.9 0.5]);
            text(880, clean_bar*scale + start_bar*0.05,'Rent spektrum', 'Color', clean_color, 'BackgroundColor',[0.7 0.9 0.7]);
            
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
        
        
        
    else
        clickState = 0;
    end
    
    
end




