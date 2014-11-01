function spectrum = ImportRawSpectrum(filename)
try
    raw_spectrum_wanted = load(filename);
    spectrum = interp1(raw_spectrum_wanted(:,1),raw_spectrum_wanted(:,2),(400:1000))';
    spectrum = [zeros(1,399) spectrum']';

catch err
    uiwait(errdlg(err.message));
    rethrow(err);
end
end

