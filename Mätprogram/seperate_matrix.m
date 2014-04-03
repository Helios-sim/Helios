function [current, voltage]=seperate_matrix(matrix)
voltage=zeros(length(matrix),1);
current=zeros(length(matrix),1);
for i=1:length(matrix)
voltage(i)=matrix(i,1);
current(i)=matrix(i,2);
end
end