function output_image = mapping_for_subregion(input_image,r1,r2,r3,rb,g1,g2,g3,gb,b1,b2,b3,bb)
%MAP_FOR Summary of this function goes here
%   Detailed explanation goes here;
%mapping
[y,x]=find(input_image(:,:,1));
output_image=input_image;
s=1;
for i=1:length(x)
    r=double(input_image(y(i),x(i),1));
    g=double(input_image(y(i),x(i),2));
    b=double(input_image(y(i),x(i),3));
    output_image(y(i),x(i),1)=s*[r,g,b,1]*[r1,r2,r3,rb]';
    output_image(y(i),x(i),2)=s*[r,g,b,1]*[g1,g2,g3,gb]';
    output_image(y(i),x(i),3)=s*[r,g,b,1]*[b1,b2,b3,bb]';
end
end


