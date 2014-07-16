function spectrum_efficiency(data, handles)
%SPECTRUM_EFFICIENCY Summary of this function goes here
%   Detailed explanation goes here

debug = getappdata(handles.figure1, 'debug_mode');
voltage = data(:,1);
current = convert_to_current(data(:,2), getappdata(handles.figure1,'R'));
Jsc = calculate_Jsc(voltage, current);
Voc = calculate_Voc(voltage,current);
FF = calculate_fill_factor(voltage,current,Jsc, Voc);
eff = calculate_efficiency(FF, Jsc, Voc, getappdata(handles.figure1,'Pin'));

if debug
            disp('IV-measurement')
            disp(strcat('Jsc: ', num2str(Jsc)));
            disp(strcat('Voc: ', num2str(Voc)));
            disp(strcat('FF: ', num2str(FF)));
            disp(strcat('eff: ', num2str(eff)));
end

set(handles.Efficiency_sign,'String',num2str(eff));
set(handles.Jsc_sign,'String',num2str(Jsc));
set(handles.Voc_sign,'String',num2str(Voc));
set(handles.FF_sign,'String',num2str(FF));

axes(handles.axes1);
plot(voltage - data(:,2),smooth(current,10));

save('SparadeSpektrum/savedMeasurement', 'voltage','current','-ascii','-tabs');

end

