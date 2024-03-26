function [col_new,row_new,output_image] = resize_image(original_col,original_row,output_imagesize)
%RESIZE_IMAGE according to the output image size
range_col=max(original_col)-min(original_col)+1;
range_row=max(original_row)-min(original_row)+1;
%range=max(range_col,range_row);
[w,h,rgbsize]=size(output_imagesize);
%rotate the shape if needed
if xor((w>h),(range_col>range_row))
    temp=original_col;
    original_col=original_row;
    original_row=temp;
    range_col=max(original_col)-min(original_col)+1;
    range_row=max(original_row)-min(original_row)+1;
end
range_output=floor(min(w/range_col,h/range_row)*100)/100;
original_image=zeros(range_col,range_row);
for i=1:1:length(original_col)
    original_image(original_col(i),original_row(i))=1;
end
original_image=logical(original_image);
J=imresize(original_image,range_output);
output_image=J;
J2 = imfill(J,'holes');
[col_new,row_new]=find(J2);
%shift to central
col_central=round((max(col_new)+min(col_new))/2);
row_central=round((max(row_new)+min(row_new))/2);
col_img=round(w/2);
row_img=round(h/2);
shift_col=col_img-col_central;
shift_row=row_img-row_central;
col_new=col_new+shift_col;
row_new=row_new+shift_row;
end

