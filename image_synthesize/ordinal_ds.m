function ordinal_dist = ordinal_ds(counts1,counts2)
%This is the implementation of the " On measuring the distance between
%histograms" from Pattern Recognition
%initialization
%counts and counts2 should be normalized histogram, or should have the same
%number of data
%counts1-> 1*b, counts2-> m*b

[~,b]=size(counts1);
[m,~]=size(counts2);
prefix_temp=zeros(m,1);
ordinal_dist=zeros(m,1);
for j=1:m
for i=1:b
    prefix_temp(j,1)=prefix_temp(j,1)+(counts1(1,i)-counts2(j,i));
    ordinal_dist(j,1)=ordinal_dist(j,1)+abs(prefix_temp(j,1));
end
end
