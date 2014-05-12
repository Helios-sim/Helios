function QE=quantum_efficiency(data, handles)

%Ska få in en matris innehållandes olika frekvenser samt deras spänning.
%Kanske ta bort skapande/borttagning sessionerna, skicka in session som invariabel i så fall.
handles = guidata(handles.figure1);

session = getappdata(handles.figure1, 'session');
voltage = data(:,1);
current = data(:,2);
L = length(voltage)
Fs = session.Rate

figure(1)
plot(voltage)

w=flattopwin(length(current),'periodic');

Y=abs(fft(current)/Fs);

frequencies = getappdata(handles.figure1, 'quantum_matrix')'

[PKS, LOCS] = findpeaks(abs(Y),'THRESHOLD', 0.02);

%Something is fishy here...
filtered_PKS = zeros(1,16);
for i = 1:16
    tmp = abs(LOCS - frequencies(i));
    [~, idx] = min(tmp + 1);
    if length(idx) > 1
       idx = idx(1); 
    end
    PKS(idx);
    filtered_PKS(1,i) = PKS(idx);
end

%Måste finna amplituderna vid de inskickade frekvenserna, räkna ström,
%dividera med varje inskickat värde med matchande frekvens. Sätt detta som
%QE.

QE = round((100*pi)*(filtered_PKS./getappdata(handles.figure1, 'quantum_spectrum')));

axes(handles.axes1);
plot(frequencies, QE);
axis([290 460 0 110]);

figure(2)
plot(Y)
axis([280 470 0 max(filtered_PKS)]);

set(handles.Efficiency_sign,'String', num2str(round(mean(QE))));
set(handles.Jsc_sign,'String', 'N/A');
set(handles.Voc_sign,'String', 'N/A');
set(handles.FF_sign,'String', 'N/A');
end