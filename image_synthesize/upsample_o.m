function v_output = upsample_o(vector,times)
%UPSAMPLE_O Summary of this function goes here
%   this function is used to upsample the output histogram
[~,y]=size(vector);
v_output=zeros(1,y*times);
for i=1:y
    for j=1:times
    v_output(1,(i-1)*times+j)=vector(1,i);
    end
end
end

