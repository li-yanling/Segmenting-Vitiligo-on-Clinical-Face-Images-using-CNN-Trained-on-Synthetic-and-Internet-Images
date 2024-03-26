clc
clear 
folder1='H:\datasets\new_vitiligo_patches_blackBG\ori_patches\';
imgList_ori = dir([folder1 '*.png']);
[~,reindex1]=sort( str2double( regexp( {imgList_ori.name}, '\d+', 'match', 'once' )));
imgList_ori=imgList_ori(reindex1);
folder2='H:\datasets\new_vitiligo_patches_blackBG\GT_patches\';
imgList_GT = dir([folder2 '*.png']);
[~,reindex1]=sort( str2double( regexp( {imgList_GT.name}, '\d+', 'match', 'once' )));
imgList_GT=imgList_GT(reindex1);
num_1 = length(imgList_GT);
%second step--get the histogram for normal skin in GT
train_vector_hist=zeros(num_1,150);
for i=1:num_1
     I=imread([folder2,imgList_GT(i).name]);
     train_vector_hist(i,:)=hist_nskin_vector_RGB_GT(I);
end
%test_image=imread('test2.jpg');
%test_vector=hist_nskin_vector_RGB_GT(test_image);
folder3='H:\dataset_for_network\unet20190508\blackbg\';
imgList_test = dir([folder3 '*.png']);
num_2 = length(imgList_test);
%no edited 
folder4='H:\dataset_for_network\unet20190508\whitebg\';
imgList_test_ori = dir([folder4 '*.png']);
%knn
for ii=1:num_2
    iter=ii
    I=imread([folder3,imgList_test(ii).name]);
    I_ori=imread([folder4,imgList_test_ori(ii).name]);
    test_image=I_ori;
    %shape
    origin_img=I;
    I=uint8(I);
    modelFile='C:\Users\yanling\Documents\MATLAB\face_keypoint_detection\choose_skin_from_face\find_face_landmarks-1.2-x64-vc14-release\lib\interfaces\matlab\shape_predictor_68_face_landmarks.dat';
    frames=find_face_landmarks(modelFile,I);
    xx=double(frames.faces(1).landmarks(:,1));
    yy=double(frames.faces(1).landmarks(:,2));
    %bbox=double(frames.faces(1).bbox);
    %connect and dark neck part
    [h,w,RGB_channel]=size(I);
    %jaw
    jaw_cor_x=vertcat(1,xx(1,1),xx(1:17,1),xx(17,1),w,w,1,1);
    jaw_cor_y=vertcat(1,1,yy(1:17,1),1,1,h,h,1);
    bw_jaw=poly2mask(jaw_cor_x,jaw_cor_y,h,w);
    %left eye
    lefteye_cor_x=xx(37:42,1);
    lefteye_cor_y=yy(37:42,1);
    bw_le=poly2mask(lefteye_cor_x,lefteye_cor_y,h,w);
    %right eye
    righteye_cor_x=xx(43:48,1);
    righteye_cor_y=yy(43:48,1);
    bw_ri=poly2mask(righteye_cor_x,righteye_cor_y,h,w);
    %mouth
    mouth_cor_x=xx(49:61,1);
    mouth_cor_y=yy(49:61,1);
    bw_mo=poly2mask(mouth_cor_x,mouth_cor_y,h,w);
    %lefteyebrow
    lefteb_cor_x=xx(18:22,1);
    lefteb_cor_y=yy(18:22,1);
    bw_leb=poly2mask(lefteb_cor_x,lefteb_cor_y,h,w);
    %rightbrow
    righteb_cor_x=xx(23:27,1);
    righteb_cor_y=yy(23:27,1);
    bw_reb=poly2mask(righteb_cor_x,righteb_cor_y,h,w);
    %add
    bw=bw_jaw+bw_le+bw_ri+bw_mo+bw_leb+bw_reb;
    bw=logical(bw);
    % fill color to the original image
    I_r=I(:,:,1);
    I_g=I(:,:,2);
    I_b=I(:,:,3);
    I_r(bw)=0;
    I_g(bw)=0;
    I_b(bw)=0;
    I=cat(3,I_r,I_g,I_b);
    %imshow(I)
    %threshold
    I=rgb2gray(I);
    level=graythresh(I);
    BW=imbinarize(I,level);
    %select biggest component 
    skin_part=select_largest_component(BW,1);
    %decide vitiligo patch size
    vector=frames.faces(1).bbox;
    height=round(0.3*vector(1,4));
    width=round(0.3*vector(1,3));
    %create distance map according to the key points
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%below is region selection
    col_final={};
while(isempty(col_final))
    [roi, center_col, center_row,shift_row,shift_col]=roi_(vector,width,height,skin_part,I);
    [r_roi,c_roi]=find(roi);
    TF=isempty(r_roi);
    while (TF)
        [roi, center_col, center_row,shift_row,shift_col]=roi_(vector,width,height,skin_part,I);
         [r_roi,c_roi]=find(roi);
        TF=isempty(r_roi);
    end
    J_skin=origin_img.*(uint8(skin_part));
    J=imcrop(J_skin,[center_col-width/2,center_row-height/2,width,height]);
    lu_x=center_col-width/2;
    lu_y=center_row-height/2;
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%above is region selection
    select_region=roi;
    %gen vitiligo
    skin_region=~(logical((~skin_part)+(~select_region)));
    %select target image
    [target, selected_color]=target_color(imgList_ori,imgList_GT,train_vector_hist,folder1,folder2,J,ii);
    %generate a random shape
    load('distribution-40-new.mat')
    real_data=mvnrnd(M_real,cov_real);
    imag_data=mvnrnd(M_imag,cov_imag);
    complex=real_data+1i*imag_data;
    %inverse DFT
    complex=complex'.*5;
    [border_ifft,col,row]=inverse_dft(complex);
    [col_new_J,row_new_J,output_image]=resize_image(col,row,J);
 
    %convert the location back to the original face
    col_new=col_new_J+double(lu_y)-1;
    row_new=row_new_J+double(lu_x)-1;
    
   %%%%%%%%%%%%%%%%%%%%%%%%repeat for the second, symmetry region;
    vitiligo_region=zeros(h,w);
    for jj=1:size(col_new)
        vitiligo_region(col_new(jj),row_new(jj))=1;
    end
    vitiligo_region=logical(vitiligo_region);
    %intersect two ROI< selected bounding box skin and vitiligo patch)
    final_region=~(logical((~skin_region)+(~vitiligo_region)));
    [col_final,row_final]=find(final_region);
end
    %Map the color to original image
    %fill the black part of J with random sampled color 
    
    source=J;
    %source
    source_lab=rgb2lab(source);
    source_I_temp=source_lab(:,:,1);
    source_I=source_I_temp;
    II=find(source_I_temp~=0);
    source_I_nozero=source_I_temp(II);
    
    source_a_temp=source_lab(:,:,2);
    source_a=source_a_temp;
    Ia=find(source_a_temp~=0);
    source_a_nozero=source_a_temp(Ia);
    
    source_b_temp=source_lab(:,:,3);
    source_b=source_b_temp;
    Ib=find(source_b_temp~=0);
    source_b_nozero=source_b_temp(Ib);
    
    [J_x,J_y,~]=size(J);
    for i=1:J_x
        for j=1:J_y
            if source_I(i,j)==0
                %source_I(i,j)=randsample(source_I_nozero,1);
                source_I(i,j)=mean(source_I_nozero);
            end
           if source_a(i,j)==0
                %source_a(i,j)=randsample(source_a_nozero,1);
                source_a(i,j)=mean(source_a_nozero);

            end
            if source_b(i,j)==0
                %source_b(i,j)=randsample(source_b_nozero,1);
                source_b(i,j)=mean(source_b_nozero);

            end
        end
    end
    %target
    target_lab=rgb2lab(target);
    target_I=target_lab(:,:,1);
    target_a=target_lab(:,:,2);
    target_b=target_lab(:,:,3);
    output_I = reinhard_histo(source_I,target_I);
    output_a= reinhard_histo(source_a,target_a);
    output_b= reinhard_histo(source_b,target_b);
    labImage = cat(3, output_I, output_a, output_b);
    J_new=lab2rgb(labImage,'OutputType','uint8');
        %Add Gaussian smmothing filter to image
    J_new=imgaussfilt(J_new,2);
         pixel_num=size(col_final);
     col_final_J=col_final+1-double(lu_y);
     row_final_J=row_final+1-double(lu_x);
     %%%%%%%%%%%%%%%%%below is for symmetry part%%%%%%

    center_row_sym=center_row;
    center_col_sym=floor(vector(1,1)+vector(1,3)-shift_col);
    %[center3_row,center3_col]=find(D3==sort_D3(1,1));
    center_row_sym=center_row_sym(1,1);
    center_col_sym=center_col_sym(1,1);
    %select the most close pixel region 
    roi=roipoly(I,[center_col_sym-width/2,center_col_sym-width/2,center_col_sym+width/2,center_col_sym+width/2],[center_row_sym-height/2,center_row_sym+height/2,center_row_sym+height/2,center_row_sym-height/2]);
    roi=~((~roi)+(~skin_part));
    [r_roi,c_roi]=find(roi);
    col_final_sym={};
    while(isempty(col_final_sym))
    while (isempty(r_roi))
               [roi, center_col_sym, center_row_sym,~,~]=roi_(vector,width,height,skin_part,I);
         [r_roi,c_roi]=find(roi);
    end
    vector_roi=zeros(1,size(r_roi,1));
    J_skin=origin_img.*(uint8(skin_part));
    J_sym=imcrop(J_skin,[center_col_sym-width/2,center_row_sym-height/2,width,height]);
    lu_x_sym=center_col_sym-width/2;
    lu_y_sym=center_row_sym-height/2;
    select_region=roi;
    %gen vitiligo
    skin_region=~(logical((~skin_part)+(~select_region)));
    %select target image
    %[target, selected_color]=target_color(imgList_ori,imgList_GT,train_vector_hist,folder1,folder2,J);
    %generate a random shape
    load('distribution-40-new.mat')
    real_data=mvnrnd(M_real,cov_real);
    imag_data=mvnrnd(M_imag,cov_imag);
    complex=real_data+1i*imag_data;
    %inverse DFT
    complex=complex'.*5;
    [border_ifft,col,row]=inverse_dft(complex);
    [col_new_J_sym,row_new_J_sym,output_image_sym]=resize_image(col,row,J_sym);
   
    %convert the location back to the original face
    col_new_sym=col_new_J_sym+double(lu_y_sym)-1;
    row_new_sym=row_new_J_sym+double(lu_x_sym)-1;
    vitiligo_region=zeros(h,w);
    for jj=1:size(col_new_sym)
        vitiligo_region(col_new_sym(jj),row_new_sym(jj))=1;
    end
    vitiligo_region=logical(vitiligo_region);
    %intersect two ROI< selected bounding box skin and vitiligo patch)
    final_region=~(logical((~skin_region)+(~vitiligo_region)));
    [col_final_sym,row_final_sym]=find(final_region);
    end
    %Map the color to original image
    %fill the black part of J with random sampled color 
    source=J_sym;
    %source
    source_lab=rgb2lab(source);
    source_I_temp=source_lab(:,:,1);
    source_I=source_I_temp;
    II=find(source_I_temp~=0);
    source_I_nozero=source_I_temp(II);
    
    source_a_temp=source_lab(:,:,2);
    source_a=source_a_temp;
    Ia=find(source_a_temp~=0);
    source_a_nozero=source_a_temp(Ia);
    
    source_b_temp=source_lab(:,:,3);
    source_b=source_b_temp;
    Ib=find(source_b_temp~=0);
    source_b_nozero=source_b_temp(Ib);
    
    [J_x,J_y,~]=size(J_sym);
    for i=1:J_x
        for j=1:J_y
            if source_I(i,j)==0
                %source_I(i,j)=randsample(source_I_nozero,1);
                source_I(i,j)=mean(source_I_nozero);
            end
           if source_a(i,j)==0
                %source_a(i,j)=randsample(source_a_nozero,1);
                source_a(i,j)=mean(source_a_nozero);

            end
            if source_b(i,j)==0
                %source_b(i,j)=randsample(source_b_nozero,1);
                source_b(i,j)=mean(source_b_nozero);

            end
        end
    end
    %target
    target_lab=rgb2lab(target);
    target_I=target_lab(:,:,1);
    target_a=target_lab(:,:,2);
    target_b=target_lab(:,:,3);
    output_I = reinhard_histo(source_I,target_I);
    output_a= reinhard_histo(source_a,target_a);
    output_b= reinhard_histo(source_b,target_b);
    labImage = cat(3, output_I, output_a, output_b);
    J_new_sym=lab2rgb(labImage,'OutputType','uint8');
        %Add Gaussian smmothing filter to image
    J_new_sym=imgaussfilt(J_new_sym,2);
         pixel_num_sym=size(col_final_sym);
     col_final_J_sym=col_final_sym+1-double(lu_y_sym);
     row_final_J_sym=row_final_sym+1-double(lu_x_sym);
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%map the mask%%%
     mask=zeros(h,w);
     for pixel_iter=1:pixel_num
        test_image(col_final(pixel_iter),row_final(pixel_iter),:)=J_new(col_final_J(pixel_iter),row_final_J(pixel_iter),:);
        mask(col_final(pixel_iter),row_final(pixel_iter))=1;
     end
     for pixel_iter=1:pixel_num_sym
        test_image(col_final_sym(pixel_iter),row_final_sym(pixel_iter),:)=J_new_sym(col_final_J_sym(pixel_iter),row_final_J_sym(pixel_iter),:);
        mask(col_final_sym(pixel_iter),row_final_sym(pixel_iter))=1;
     end
     test_image=imresize(test_image,[512,512]);
    imwrite(test_image,['RGB','-',num2str(ii),'.png'])
    %generate mask
    mask=mask./255;
    mask=imresize(mask,[512,512]);
    imwrite(mask, ['Mask','-',num2str(ii),'.png'])
    imwrite(I_ori,['Ori','-',num2str(ii),'.png'])
%     figure
%     subplot(1,2,1)
%     imshow(test_image)
%     subplot(1,2,2)
%     imshow(selected_color)
%     fig=gcf;
%     saveas(fig,['colorcompare','-',num2str(ii),'.png'])
t = datetime('now')
end