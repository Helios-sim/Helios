function process_data(data, timestamps, handles)
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here

% voltage = data(:,1);
% current = convert_to_current(data(:,2), getappdata(handles.figure1,'R'));
guidata(handles.figure1, handles);
switchCase = getappdata(handles.figure1, 'measurement_type'); 

switch(switchCase)
    case('specificSpectrum')
            voltage = data(:,1);
            current = data(:,2);
            Jsc = calculate_Jsc(voltage, current);
            Voc = calculate_Voc(voltage,current);
            FF = calculate_fill_factor(voltage,current,Jsc, Voc);
            eff = calculate_efficiency(FF, Jsc, Voc, getappdata(handles.figure1,'Pin'));
            
            set(handles.Efficiency_sign,'String',num2str(eff));
            set(handles.Jsc_sign,'String',num2str(Jsc));
            set(handles.Voc_sign,'String',num2str(Voc));
            set(handles.FF_sign,'String',num2str(FF));
            
            axes(handles.axes1);
            plot(timestamps,voltage);
            plot(timestamps,current);
            guidata(handles.figure1, handles);
       % plot(timestamps,data(:,3));
    case('QuantumEfficiency')
        %Do other stuff here, uses time;
    otherwise
        return;
end
end