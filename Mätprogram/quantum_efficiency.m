function QE=quantum_efficiency(data, handles)

%Ska få in en matris innehållandes olika frekvenser samt deras spänning.
%Kanske ta bort skapande/borttagning sessionerna, skicka in session som invariabel i så fall.
try
    handles = guidata(handles.figure1);
    
    session = getappdata(handles.figure1, 'session');
    voltage = data(:,1);
    current = data(:,2);
    L = length(voltage);
    Fs = session.Rate;
    
    figure(1)
    plot(voltage)
    
    w=flattopwin(length(current),'periodic');
    Y=abs(fft(current)/Fs);
    
    frequencies = getappdata(handles.figure1, 'quantum_matrix')';
    
    [PKS, LOCS] = findpeaks(abs(Y),'THRESHOLD', 0.02);
    
    filtered_PKS = zeros(1,16);
    if length(PKS) >= 16
        for i = 1:16
            tmp = abs(LOCS - frequencies(i));
            [~, idx] = min(tmp + 1);
            if length(idx) > 1
                idx = idx(1);
            end
            filtered_PKS(1,i) = PKS(idx);
        end
    else
        for i = 1:length(PKS)
            tmp = abs(LOCS - frequencies(i));
            [~, idx] = min(tmp + 1);
            if length(idx) > 1
                idx = idx(1);
            end
            filtered_PKS(1,i) = PKS(idx);
        end
    end
    
    QE = round((100*pi)*(filtered_PKS./getappdata(handles.figure1, 'quantum_spectrum')));
    for i = 1:length(QE)
        if(QE(i) == inf)
            QE(i) = 0;
        end
    end
    
    axes(handles.axes1);
    plot(frequencies, QE);
    axis([290 460 0 110]);
    
    figure(2)
    plot(Y)
    if length(filtered_PKS > 0)
        axis([280 470 0 max(filtered_PKS)]);
    else
        axis([280 470 0 1]);
    end
    set(handles.Efficiency_sign,'String', num2str(round(mean(QE))));
    set(handles.Jsc_sign,'String', 'N/A');
    set(handles.Voc_sign,'String', 'N/A');
    set(handles.FF_sign,'String', 'N/A');
    
catch err
    err.identifier
    rethrow(err);
end
end