function [voltage, current]=seperate_matrix(matrix,R)
voltage=zeros(length(matrix),1);
current=zeros(length(matrix),1);
for i=1:length(matrix)
voltage(i)=matrix(i,1);
current(i)=matrix(i,2);
current(i)/R;
end
end