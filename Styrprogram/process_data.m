function process_data(data, timestamps, handles)
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here
try
    handles = guidata(handles.figure1);
    voltage = data(:,1);
    current = convert_to_current(data(:,2), getappdata(handles.figure1,'R'));
    switchCase = getappdata(handles.figure1, 'measurement_type');
    
    switch(switchCase)
        case('specificSpectrum')
            Jsc = calculate_Jsc(voltage, current);
            Voc = calculate_Voc(voltage,current);
            FF = calculate_fill_factor(voltage,current,Jsc, Voc);
            eff = calculate_efficiency(FF, Jsc, Voc, getappdata(handles.figure1,'Pin'));
            
            set(handles.Efficiency_sign,'String',num2str(eff));
            set(handles.Jsc_sign,'String',num2str(Jsc));
            set(handles.Voc_sign,'String',num2str(Voc));
            set(handles.FF_sign,'String',num2str(FF));
            
            axes(handles.axes1);
            v=getappdata(handles.figure1,'from_iv'):(getappdata(handles.figure1,'to_iv')-getappdata(handles.figure1,'from_iv'))/(length(current)):getappdata(handles.figure1,'to_iv')-(1/(length(current)));
            plot(v,current);
            
            save('SparadeSpektrum/savedMeasurement', 'voltage','current','-ascii','-tabs');
        case('QuantumEfficiency')
            quantum_efficiency(data, handles);
        otherwise
            return;
    end
    guidata(handles.figure1, handles);
    
catch err
    if strcmp(err.identifier, 'MATLAB:indexOutOfBounds')
        disp('No data has been aqcuired, connect the analog input DAQ-card');
        
    else
        disp(err.identifier);
        rethrow(err)
    end
end
end