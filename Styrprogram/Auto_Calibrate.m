function [ tight, new_daq_voltage, success ] = Auto_Calibrate(handles, slack)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here
try
    
    tight = false;
    new_daq_voltage = zeros(1,16);
    success = false;
    
    handles = guidata(handles.figure1);
    debug = getappdata(handles.figure1, 'debug_mode');
    
    [measured_spectrum, success] = getSpectrum(handles);
    if success
        
        wanted_spectrum = getappdata(handles.figure1, 'wanted_spectrum');
        daq_voltage = getappdata(handles.figure1, 'chosen_spectrum');
        
        axes = handles.axes1;
        if debug
            disp('in Auto_Calibrate');
            disp(['axes: ' num2str(axes)]);
        end
        
        tight = true;
        
        %In order of wavelengths
        max_I = [350 350 250 350 350 350 350 350 600 600 800 800 800 1000 1000 500]*0.001;
        FF = getappdata(handles.figure1, 'amp_factor');
        forstarkningsfaktor = ChaToWave(FF);
        max_voltage = max_I./forstarkningsfaktor;
        
        for i = 1:16
            if max_voltage(i) > 10
                max_voltage(i) = 10;
            end
        end
        
        %Calibrate_Spectrum does all the calculations with a voltage-vector
        %arranged in rising wavelength order.
        %At the end of the function, it switches back to give a vector of voltages in order of channels.
        tmp_voltage = ChaToWave(daq_voltage);
        
        
        %Keep track on the diodes that are already maxed
        maxed = zeros(1,16);
        for i = 1:16
            if tmp_voltage(i) >= max_voltage(i)*0.9995
                tmp_voltage(i) = max_voltage(i)*0.9995;
                maxed(i) = true;
            end
        end
        
        
        %The diodes wavelengths for peakemission
        %                   1    2   3   4   5   6   7   8   9   10  11  12  13  14
        diode_placements = [420 450 490 515 520 590 630 660 680 720 750 780 830 880 945 980];
        
        
        %Wanted intensities at 100 nm intervals
        Iwant1 = sum(wanted_spectrum(400:499));
        Iwant2 = sum(wanted_spectrum(500:599));
        Iwant3 = sum(wanted_spectrum(600:699));
        Iwant4 = sum(wanted_spectrum(700:799));
        Iwant5 = sum(wanted_spectrum(800:899));
        Iwant6 = sum(wanted_spectrum(900:1000));
        Iwant = [Iwant1 Iwant2 Iwant3 Iwant4 Iwant5 Iwant6];
        
        disp(length(measured_spectrum))
        %Intensities which we have measured in the 100 nm intervals
        Ihave1 = sum(measured_spectrum(400:499));
        Ihave2 = sum(measured_spectrum(500:599));
        Ihave3 = sum(measured_spectrum(600:699));
        Ihave4 = sum(measured_spectrum(700:799));
        Ihave5 = sum(measured_spectrum(800:899));
        Ihave6 = sum(measured_spectrum(900:1000));
        Ihave = [Ihave1 Ihave2 Ihave3 Ihave4 Ihave5 Ihave6];
        
        
        %Relative distances per diode in aspect to measured vs wanted light intensities for
        %wavelengths as plus minus 5 nm from the peak emission wavelengths.
        %This is to determine which diodes voltage that are to be adjusted. The relative intensity is paired
        %with the corresponding channel number in the second row of the rel_int vector,
        %and the third row shows if the diodes are maxed.
        rel_int = [zeros(1,16); 1:16; maxed];
        wanted_intensity = zeros(1,16);
        measured_intensity = zeros(1,16);
        for n = 1:16
            wanted_intensity(n) = sum(wanted_spectrum(diode_placements(n)-5:diode_placements(n)+5));
            measured_intensity(n) = sum(measured_spectrum(diode_placements(n)-5:diode_placements(n)+5));
        end
        rel_int(1,:) = measured_intensity./wanted_intensity;
        
        
        
        
        
        %Fix the intensity for all the 100 nm intervals
        for i = 1:6
            if Ihave(i) > Iwant(i)*(1 + slack)
                if debug
                    disp(['Decrease intensity in interval nr: ' num2str(i)])
                end
                %We want less intensity than what we have, fix it
                [rel_int, tmp_voltage] = DownInt(tmp_voltage, rel_int, i, max_voltage, debug);
                
                %We did adjustments, so we're not sure the spectrum is tightly followed
                tight = false;
                
            elseif Ihave(i) < Iwant(i)*(1 - slack)
                if debug
                    disp(['Increase intensity in interval nr: ' num2str(i)])
                end
                [tight, rel_int, tmp_voltage] = UpInt( tmp_voltage, rel_int, i, max_voltage, Ihave, Iwant, debug);
                
            end
            
        end
        
        
        %Failtest uses a vector on the channel-order form. We also want to return
        %the new_daq_voltage on the channel form
        new_daq_voltage = WaveToCha(tmp_voltage);
        
        if failtest(new_daq_voltage)
            error('CalibrateSpectrum:Bad_spectrum', 'The function which calibrates the spectrum made a misstake, which resulted in too high output voltages');
        end
        
        setappdata(handles.figure1, 'chosen_spectrum', new_daq_voltage);
        guidata(handles.figure1, handles);
    end
    
catch err
    shutdown_simulator(handles);
    rethrow(err)
end

end

