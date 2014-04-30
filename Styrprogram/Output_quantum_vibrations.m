function Output_quantum_vibrations(handles)
voltage = [handles.from_iv:handles.step_iv:handles.to_iv, 1];
spectrum = (handles.quantum_spectrum).*ones(length(voltage),16);
frequency_matrix = create_frequency_matrix(handles.frequencies, number_of_scans);

handles.session.queueOutputData([frequency_matrix de2bi(voltage) spectrum]);
handles.session.startBackground;
end

