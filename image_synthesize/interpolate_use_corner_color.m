function output_image = interpolate_use_corner_color(input_image,V_R,V_G,V_B)
%INTERPOLATE_USE_CORNER_COLOR Summary of this function goes here
%   use the four corner of the bounding box color to predict other colors
%into 5*5 interpolation
[h,w,channel]=size(input_image);
x=[1,5];
y=[1,5];
[X,Y]=meshgrid(x,y);
xq=[1,2,3,4,5];
yq=[1,2,3,4,5];
[Xq,Yq]=meshgrid(xq,yq);
Vq_R = interp2(X,Y,V_R,Xq,Yq,'linear',0);
Vq_G = interp2(X,Y,V_G,Xq,Yq,'linear',0);
Vq_B = interp2(X,Y,V_B,Xq,Yq,'linear',0);
w_b=round(w/5);
h_b=round(h/5);

%Assign  the interpolated result to image
r=input_image(:,:,1);
g=input_image(:,:,2);
b=input_image(:,:,3);
for i=1:1:4
    for j=1:1:4
        r((i-1)*h_b+1:i*h_b,(j-1)*w_b+1:j*w_b)=Vq_R(i,j);
        g((i-1)*h_b+1:i*h_b,(j-1)*w_b+1:j*w_b)=Vq_G(i,j);
        b((i-1)*h_b+1:i*h_b,(j-1)*w_b+1:j*w_b)=Vq_B(i,j);
    end
end
for i=5
    for j=1:4
        r((i-1)*h_b+1:h,(j-1)*w_b+1:j*w_b)=Vq_R(i,j);
        g((i-1)*h_b+1:h,(j-1)*w_b+1:j*w_b)=Vq_G(i,j);
        b((i-1)*h_b+1:h,(j-1)*w_b+1:j*w_b)=Vq_B(i,j);
        
    end
end
for j=5
    for i=1:4
        r((i-1)*h_b+1:i*h_b,(j-1)*w_b+1:w)=Vq_R(i,j);
        g((i-1)*h_b+1:i*h_b,(j-1)*w_b+1:w)=Vq_G(i,j);
        b((i-1)*h_b+1:i*h_b,(j-1)*w_b+1:w)=Vq_B(i,j);
    end
end
i=5;
j=5;
r((i-1)*h_b+1:h,(j-1)*w_b+1:w)=Vq_R(i,j);
g((i-1)*h_b+1:h,(j-1)*w_b+1:w)=Vq_G(i,j);
b((i-1)*h_b+1:h,(j-1)*w_b+1:w)=Vq_B(i,j);
output_image=cat(3,r,g,b);
imshow(output_image)
end

