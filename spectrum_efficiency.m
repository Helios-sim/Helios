function [ output_args ] = spectrum_efficiency(data, handles)
%SPECTRUM_EFFICIENCY Summary of this function goes here
%   Detailed explanation goes here

voltage = data(:,1);
current = convert_to_current(data(:,2), getappdata(handles.figure1,'R'));
Jsc = calculate_Jsc(voltage, current);
Voc = calculate_Voc(voltage,current);
FF = calculate_fill_factor(voltage,current,Jsc, Voc);
eff = calculate_efficiency(FF, Jsc, Voc, getappdata(handles.figure1,'Pin'));

set(handles.Efficiency_sign,'String',num2str(eff));
set(handles.Jsc_sign,'String',num2str(Jsc));
set(handles.Voc_sign,'String',num2str(Voc));
set(handles.FF_sign,'String',num2str(FF));

axes(handles.axes1);
plot(voltage - data(:,2),smooth(current,10));

save('SparadeSpektrum/savedMeasurement', 'voltage','current','-ascii','-tabs');

end

