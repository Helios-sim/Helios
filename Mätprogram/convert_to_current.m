function matrix=convert_to_current(matrix_in, R)

for i=1:length(matrix_in)
    matrix_in(i,2)=matrix_in(i,2)/R;
end
matrix=matrix_in;
end

