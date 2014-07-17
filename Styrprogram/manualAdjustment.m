function manualAdjustment (handles)
try
    clickState = getappdata(handles.figure1, 'clickState');
    while (clickState == 1)
        
        measured_spectrum =
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
        plot(ydiodes,'k');
        plot(measured_spectrum)
        axis([400 1000 0 top_y*1.2])
        
        %axesHandle  = get(objectHandle,'Parent');
        
        [x_cord, ~, button] = ginput(1);
        
        if button == 1
            manRaiseOne(handles, x_cord);
            
        elseif button == 2
            raiseTheBar(handles);
            
        %If the user didn't left-click or middle-click when she/he saw the spikes, then go back
        else
            setappdata(handles.figure1, 'clickState' ,0);
            
        end
    end
    
catch err
    if(strcmp(err.identifier, 'MATLAB:undefinedVarOrFunction'))
        helpdlg(err.message);
        rethrow(err);
    elseif (strcmp(err.identifier, 'MATLAB:ginput:FigureDeletionPause'))
        helpdlg(err.message);
        rethrow(err);
    else
        rethrow(err);
    end
end
end
