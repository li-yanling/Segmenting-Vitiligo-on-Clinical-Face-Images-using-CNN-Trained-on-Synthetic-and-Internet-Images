function [roi,center_col,center_row,shift_row,shift_col] = roi_(vector,width,height,skin_part,gray_img)
%ROI_ Summary of this function goes here
%   This function is used to calculate roi for color transferring. avoid
%   empty source
    shift_row=rand*vector(1,4);
    shift_col=rand*vector(1,3);
    center_row=floor(vector(1,2)+shift_row);
    center_col=floor(vector(1,1)+shift_col);
    %[center3_row,center3_col]=find(D3==sort_D3(1,1));
    center_row=center_row(1,1);
    center_col=center_col(1,1);
    %select the most close pixel region 
    
    roi=roipoly(gray_img,[center_col-width/2,center_col-width/2,center_col+width/2,center_col+width/2],[center_row-height/2,center_row+height/2,center_row+height/2,center_row-height/2]);
    roi=~((~roi)+(~skin_part));
end

