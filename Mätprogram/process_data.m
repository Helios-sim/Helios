function process_data(data, timestamps, handles)
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here

voltage = data(:,1);
current = convert_to_current(data(:,2), getappdata(handles.figure1,'R'));
handles = guidata(handles.figure1);
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
        plot(voltage,current);
        
        
        save('SparadeSpektrum/savedMeasurement', 'voltage','current','-ascii','-tabs');
        % plot(timestamps,data(:,3));
    case('QuantumEfficiency')
        %         testing
        %         session = getappdata(handles.figure1,'session');
        %         [strommatris, frekvenser] = createSquareWave(length(data), session.Rate);
        %         quantum_matrix = getappdata(handles.figure1, 'quantum_spectrum');
        %         for i = 1:16
        %         strommatris(:,i) = quantum_matrix(1,i)*strommatris(:,i);
        %         end
        %         S = sum(strommatris,2);
        %
        %         a=ones(length(data),1);
        %         a(1:length(data)/2)=2;
        %         matdata = [a, S];
        quantum_efficiency(matdata, handles);
    otherwise
        return;
end
guidata(handles.figure1, handles);
end