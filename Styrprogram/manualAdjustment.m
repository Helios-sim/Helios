function manualAdjustment (handles)
try
    handles = guidata(handles.figure1);
    debug = getappdata(handles.figure1, 'debug_mode');
    clickState = getappdata(handles.figure1, 'clickState');
    spectCon = getappdata(handles.figure1,'spectCon');
    measured_spectrum = getappdata(handles.figure1, 'measured_spectrum');
    wanted_spectrum = getappdata(handles.figure1, 'wanted_spectrum');
    axes = handles.axes1;
    if debug
        disp('in manualAdjustment')
        disp(['axes: ' num2str(axes)]);
        disp(['clickstate: ' num2str(clickState)]);
    end
    
    while (clickState == 1)
        
        d = 1/4;
        ydiodes(420) = d;
        ydiodes(450) = d;
        ydiodes(490) = d;
        ydiodes(515) = d;
        ydiodes(520) = d;
        ydiodes(590) = d;
        ydiodes(630) = d;
        ydiodes(660) = d;
        ydiodes(680) = d;
        ydiodes(720) = d;
        ydiodes(750) = d;
        ydiodes(780) = d;
        ydiodes(830) = d;
        ydiodes(880) = d;
        ydiodes(945) = d;
        ydiodes(980) = d;
        
        % Showing the diode spikes and the spectrum, left or right-click to proceed and right
        % click to go back
        cla;
        plot(wanted_spectrum/max(wanted_spectrum),'color',[1 0 0]);
        plot(ydiodes,'k');
        if spectCon
            plot(measured_spectrum/max(measured_spectrum));
        end
        xlabel('Wavelength [nm]')
        ylabel('Power [Arbitrary]')
        axis([400 1000 0 1.2])
        
        [x_cord, y_cord, button, axn] = ginputax(axes,1);
        
        if (x_cord < 0 || x_cord > 1000 || y_cord < 0 || y_cord > 1.2)
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
            RaiseAll(handles,measured_spectrum,wanted_spectrum);
            
            %If the user don't left-click or middle-click when she/he see the spikes, then go back
        else
            if debug
                disp('neither left- nor middle-click');
            end
            cla;
            plot(wanted_spectrum/max(wanted_spectrum),'color',[1 0 0]);
            if spectCon
                plot(measured_spectrum/max(measured_spectrum))
            end
            xlabel('Wavelength [nm]')
            ylabel('Power [Arbitrary]')
            axis([400 1000 0 1.2])
            clickState = 0;
            setappdata(handles.figure1, 'clickState' ,0);
            
            guidata(handles.figure1, handles);
            
        end
        if spectCon
            cla;
            Simulator_on(handles, handles.Simulator_on)
            measured_spectrum = getSpectrum(handles);
            setappdata(handles.figure1, 'measured_spectrum' ,measured_spectrum);
        end
    end
    setappdata(handles.figure1,'filter',ones(1,16));
    guidata(handles.figure1, handles);
    
catch err
    if(strcmp(err.identifier, 'MATLAB:undefinedVarOrFunction'))
        uiwait(errordlg(err.message));
    end
    rethrow(err);
end
end
