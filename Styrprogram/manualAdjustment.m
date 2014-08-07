function manualAdjustment (handles)
try
    handles = guidata(handles.figure1);
    debug = getappdata(handles.figure1, 'debug_mode');
    clickState = getappdata(handles.figure1, 'clickState');
    measured_spectrum = getappdata(handles.figure1, 'measured_spectrum');
    axes = handles.axes1;
    if debug
        disp('in manualAdjustment')
        disp(['axes: ' num2str(axes)]);
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
        plot(ydiodes,'k');
        plot(measured_spectrum)
        xlabel('Våglängd [nm]')
        ylabel('Effekt [W]')
        axis([400 1000 0 top_y*1.2])
        
        [x_cord, y_cord, button, axn] = ginputax(axes,1);
        
        if (x_cord < 0 || x_cord > 1000 || y_cord < 0 || y_cord > top_y*1.2)
            if debug
                disp(strcat('x_cord: ', num2str(x_cord)));
                disp(strcat('y_cord: ', num2str(y_cord)));
            end
            setappdata(handles.figure1, 'clickState' ,0);
            guidata(handles.figure1, handles);
            return;
        end
        
        
        if button == 1
            manRaiseOne(handles, x_cord, measured_spectrum);
            
        elseif button == 2
            RaiseTheBar(handles, measured_spectrum);
            
            %If the user don't left-click or middle-click when she/he see the spikes, then go back
        else
            
            cla;
            plot(measured_spectrum)
            xlabel('Våglängd [nm]')
            ylabel('Effekt [W]')
            axis([400 1000 0 top_y*1.2])
            clickState = 0;%Redundance?
            setappdata(handles.figure1, 'clickState' ,0);
            guidata(handles.figure1, handles);
            
        end
        [measured_spectrum, ~] = getSpectrum(handles);
    end
    guidata(handles.figure1, handles);
    
catch err
    if(strcmp(err.identifier, 'MATLAB:undefinedVarOrFunction'))
        uiwait(errordlg(err.message));
    end
        rethrow(err);
end
end
