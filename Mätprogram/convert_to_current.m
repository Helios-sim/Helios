function matrix=convert_to_current(matrix_in, R)
%�verfl�dig funktion, konvertering redan gjort i write/read_daq funktion.
for i=1:length(matrix_in)
    matrix_in(i)=matrix_in(i)/R;
end
matrix=matrix_in;
end

