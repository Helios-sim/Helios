function QE=quantum_efficiency(data, handles)

%Ska få in en matris innehållandes olika frekvenser samt deras spänning.

try
    handles = guidata(handles.figure1);
    
    session = getappdata(handles.figure1, 'session');
    voltage = data(:,1);
    current = convert_to_current(data(:,2), getappdata(handles.figure1,'R'));
    L = length(voltage);
    Fs = session.Rate;
    
    figure(1)
    plot(current)
    
    w=flattopwin(length(current),'periodic');
    Y=abs(fft(current));
   
    frequencies = getappdata(handles.figure1, 'quantum_matrix')';
    
    figure(2)
    plot(Y)
    
    [PKS, LOCS] = findpeaks(abs(Y),'THRESHOLD', 0.001);
    PKS
    LOCS
    filtered_PKS = zeros(1,16);
  
        for i = 1:16
            tmp = abs(LOCS - frequencies(i));
            if min(tmp)<5
            [~, idx] = min(tmp - 1);
            if length(idx) > 1
                idx = idx(1);
            end
            filtered_PKS(1,i) = PKS(idx)
            end
        end
  
    
    figure(3)
    scatter(frequencies,filtered_PKS)
    
    % intensitet för kanal:           1  2   3   4   5   6  7  8   9   10  11  12  13  14  15 16
    currentIntensity = (1/(0.83*5))*[2.5 2.9 1.3 3.8 4.5 3 1.9 4.3 4.7 4.5 3.8 2.6 4.6 2.8 3 4.6];
    
    %konvertera ström till total effekt, DUBBELKOLLA!!
    P = (getappdata(handles.figure1, 'quantum_spectrum')*(1.8).*currentIntensity*getappdata(handles.figure1,'illuminated_area'));
    
    wavelengths = [590 720 980 830 880 945 680 520 420 450 780 630 660 750 490 515]*1e-9;
    h = 6.6261e-34;
    c = 3e8;
    photons = P./((h*c)./wavelengths);
    
    %konvertera ström till antal elektroner
    electrons = filtered_PKS/(1.602e-19);
    
    QE = round(electrons./photons);
    
    for i = 1:length(QE)
        if(QE(i) == inf)
            QE(i) = 0;
        end
    end
    
    axes(handles.axes1);
    
    light_wavelengths = [420 450 490 515 520 590 630 660 680 720 750 780 830 880 945 980];
    wavelength_efficiency = [QE(9) QE(10) QE(15) QE(16) QE(8) QE(1) QE(12) QE(13) QE(7) QE(2) QE(14) QE(11) QE(4) QE(5) QE(6) QE(3)];
    
    
    plot(light_wavelengths, wavelength_efficiency);
    axis([420 980 0 110]);

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