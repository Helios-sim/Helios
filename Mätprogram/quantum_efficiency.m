function QE=quantum_efficiency(data, handles, debug)

%Ska få in en matris innehållandes olika frekvenser samt deras spänning.

try
    handles = guidata(handles.figure1);
    frequencies = getappdata(handles.figure1, 'quantum_matrix')';
    area = getappdata(handles.figure1,'illuminated_area');
    quantum_spectrum = getappdata(handles.figure1, 'quantum_spectrum');
    current = convert_to_current(data(:,2), getappdata(handles.figure1,'R'));
    
    % dessa värden behöver kalibreras noggrant och ordentligt
    % intensitet för kanal:           1  2   3   4   5   6  7  8   9   10  11  12  13  14  15 16
    currentIntensity = (1/(0.83*2))*[2.5 2.9 1.3 3.8 4.5 3 1.9 4.3 4.7 4.5 3.8 2.6 4.6 2.8 3 4.6];
    wavelengths = [590 720 980 830 880 945 680 520 420 450 780 630 660 750 490 515]*1e-9;
    light_wavelengths = [420 450 490 515 520 590 630 660 680 720 750 780 830 880 945 980];
    
    if debug
        disp('In quantum_efficiency:   ');
        disp('Frequencies: ');
        disp(frequencies);
        disp('Quantum_spectrum: ');
        disp(quantum_spectrum);
        disp('area: ', area);
        disp('current: ');
        disp(size(current));        
    end
    
    Y=abs(fft(current));
    [PKS, LOCS] = findpeaks(abs(Y),'THRESHOLD', 0.001);
    
    filtered_PKS = zeros(1,16);
    for i = 1:16
        tmp = abs(LOCS - frequencies(i));
        if min(tmp)<5
            [~, idx] = min(tmp - 1);
            if length(idx) > 1
                idx = idx(1);
            end
            filtered_PKS(1,i) = PKS(idx);
        end
    end
    
    if debug
        disp('filtered_PKS:');
        disp(filtered_PKS);
    end
    
    
    P = quantum_spectrum*(1.8).*currentIntensity*area;
    h = 6.6261e-34;
    c = 3e8;
    photons = P./((h*c)./wavelengths);
    %konvertera ström till antal elektroner
    electrons = filtered_PKS/(1.602e-19);
    QE = round(electrons./photons);
    
    for i = 1:length(QE)
        if(QE(i) == inf)
            QE(i) = 0;
        elseif QE(i) > 1 && debug
            faults = faults + 1;
            disp(strcat('QE = ',num2str(QE(i))));            
            disp(strcat('electrons = ',num2str(electrons(i))));
            disp(strcat('photons = ', num2str(photons(i))));
        end
    end
    wavelength_efficiency = [QE(9) QE(10) QE(15) QE(16) QE(8) QE(1) QE(12) QE(13) QE(7) QE(2) QE(14) QE(11) QE(4) QE(5) QE(6) QE(3)];
    
    figure(1)
    plot(current)
    figure(2)
    plot(Y)
    figure(3)
    scatter(frequencies,filtered_PKS)
    
    axes(handles.axes1);
    plot(light_wavelengths, wavelength_efficiency);
    axis([420 980 0 110]);
    
    set(handles.Efficiency_sign,'String', num2str(round(mean(QE))));
    set(handles.Jsc_sign,'String', 'N/A');
    set(handles.Voc_sign,'String', 'N/A');
    set(handles.FF_sign,'String', 'N/A');
    
catch err
    disp(strcat(err.identifier, ': ' ,err.message));
    rethrow(err);
end
end