function manualAdjustment (handles)
try
    handles = guidata(handles.figure1);
    debug = getappdata(handles.figure1, 'debug_mode');
    clickState = getappdata(handles.figure1, 'clickState');
    measured_spectrum = getappdata(handles.figure1, 'measured_spectrum');
    wanted_spectrum = getappdata(handles.figure1, 'wanted_spectrum');
    axes = handles.axes1;
    if debug
        disp('in manualAdjustment')
        disp(['axes: ' num2str(axes)]);
        disp(['clickstate: ' num2str(clickState)]);
    end
    
    while (clickState == 1)
        
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
        
        % Showing the diode spikes and the spectrum, left or right-click to proceed and right
        % click to go back
        cla;
        plot(wanted_spectrum/2/max(wanted_spectrum)*max(measured_spectrum),'color',[1 0 0]);
        %         plot(wanted_spectrum,'HitTest','off')
        plot(ydiodes,'k', 'HitTest','off');
        plot(measured_spectrum, 'HitTest','off')
        xlabel('Våglängd [nm]')
        ylabel('Effekt []')
        axis([400 1000 0 top_y*1.2])
        
        [x_cord, y_cord, button, axn] = ginputax(axes,1);
        
        if (x_cord < 0 || x_cord > 1000 || y_cord < 0 || y_cord > top_y*1.2)
            if debug
                disp(strcat('x_cord: ', num2str(x_cord)));
                disp(strcat('y_cord: ', num2str(y_cord)));
            end
            setappdata(handles.figure1, 'clickState' ,0);
            guidata(handles.figure1, handles);
            disp('clicked outside of graph. Returning from manualAdjusment and setting clickState to 0');
            return;
        end
        
        
        if button == 1
            if debug
                disp('left-click');
            end
            manRaiseOne(handles, x_cord, measured_spectrum,wanted_spectrum);
            
        elseif button == 2
            if debug
                disp('middle-click');
            end
            %             RaiseTheBar(handles, measured_spectrum,wanted_spectrum);
            RaiseAll(handles,measured_spectrum,wanted_spectrum);
            
            %If the user don't left-click or middle-click when she/he see the spikes, then go back
        else
            if debug
                disp('neither left- nor middle-click');
            end
            cla;
            plot(wanted_spectrum,'color',[1 0 0]);
            plot(measured_spectrum/max(measured_spectrum)*max(wanted_spectrum), 'HitTest','off')
            xlabel('Våglängd [nm]')
            ylabel('Effekt [W]')
            axis([400 1000 0 top_y*1.2])
            clickState = 0;
            setappdata(handles.figure1, 'clickState' ,0);
            guidata(handles.figure1, handles);
            
        end
        Simulator_on(handles, handles.Simulator_on)
        [measured_spectrum, ~] = getSpectrum(handles);
        setappdata(handles.figure1, 'measured_spectrum' ,measured_spectrum);
    end
    guidata(handles.figure1, handles);
    
catch err
    if(strcmp(err.identifier, 'MATLAB:undefinedVarOrFunction'))
        uiwait(errordlg(err.message));
    end
    rethrow(err);
end
end
