function [border_ifft,col,row]= inverse_dft(border_fft)
%INVERSE_DFT Summary of this function goes here
%   Detailed explanation goes here
ncoef=39;
lenf=size(border_fft,1);
border_ifft=zeros(1,lenf);
  
   if mod(lenf,2) % odd
	lenf = lenf-1;
   end
    rc = fix(lenf/2)+1;  


p1=[ (rc+1):(rc+1+ncoef-1)];
p2=[ (rc-1):-1:(rc-1-ncoef+1)];



border_ifft=zeros(1,lenf);
for ind=1:(ncoef)
    mfreq_vec=zeros(1,lenf);
   mfreq_vec(p1(ind))=border_fft(p1(ind));
    mfreq_vec(p2(ind))=border_fft(p2(ind));
    
    border_ifft = border_ifft+(ifft(ifftshift(mfreq_vec)));
end

%add dc
 mfreq_vec=zeros(1,lenf);
 mfreq_vec(rc)=border_fft(rc);
 border_ifft = border_ifft+(ifft(ifftshift(mfreq_vec)));
 
xx=real(border_ifft);yy=imag(border_ifft);
yyt=round(yy);xxt=round(xx);

%restore the image
yyt=horzcat(yyt,yyt(1));xxt=horzcat(xxt,xxt(1));
subplot(1,3,1)
%shift the min value to zero.
x_min=min(xxt);
y_min=min(yyt);
xxt=xxt-x_min;
yyt=yyt-y_min;
% labels=cellstr(num2str([1:length(xxt)]'));
% plot((xxt),yyt,'x-');
% set(gca,'XAxisLocation','top','YAxisLocation','left','ydir','reverse');
% axis equal
% text((xxt),yyt,labels,'VerticalAlignment','bottom','HorizontalAlignment','right')
% title('Coordinates plot')
% subplot(1,3,2)
bw1=poly2mask(xxt+5,yyt+5,(max(yyt)-min(yyt))+20,(max(xxt)-min(xxt)+20));
[r,c,~]=size(bw1);
I=zeros(r,c);
bw=roispline(I,'natural',0,xxt',yyt');
se=strel('sphere',5);
J1=imdilate(bw,se);
J2=imfill(J1,'holes');
J=logical(J2+bw1);
% imshow(J)
% imwrite(J,['output','.png'])
% title('Dilated')
[col,row]=find(J);
end

