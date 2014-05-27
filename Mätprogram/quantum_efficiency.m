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
    
    % intensitet för kanal:         1  2   3   4   5   6 7   8   9   10  11  12  13  14  15 16
    currentIntensity = (1/(0.83*5))*[2.5 2.9 1.3 3.8 4.5 3 1.9 4.3 4.7 4.5 3.8 2.6 4.6 2.8 3 4.6];
    
    %konvertera ström till total effekt
    P = (getappdata(handles.figure1, 'quantum_spectrum')*(1.8).*currentIntensity*getappdata(handles.figure1,'illuminated_area'));
    wavelengths = [590 720 980 830 880 945 680 520 420 450 780 630 660 750 490 515]*1e-9;
    h = 6.6261e-34;
    c = 3e8;
    photons = P./(h*c./wavelengths);
    
    %konvertera ström till antal elektroner
    electrons = filtered_PKS/(1.602e-19);
    
    QE = round((100*pi)*(electrons./photons));
    
    for i = 1:length(QE)
        if(QE(i) == inf)
            QE(i) = 0;
        end
    end
    
    axes(handles.axes1);
    plot(frequencies, QE);
    axis([290 460 0 110]);

%     figure(2)
%     plot(Y)

    set(handles.Efficiency_sign,'String', num2str(round(mean(QE))));
    set(handles.Jsc_sign,'String', 'N/A');
    set(handles.Voc_sign,'String', 'N/A');
    set(handles.FF_sign,'String', 'N/A');
    
catch err
    err.identifier
    rethrow(err);
end
end