function [vitiligo_image,I_ori] = target_color(imgList_ori,imgList_GT,train_vector_hist,folder1,folder2,J,ii)
%TARGET_COLOR Summary of this function goes here
%   from the vitiligo database, use 1NN , based on the closet skin color to
%   decide the target skin color
test_vector1=hist_skin_vector(J);
   %select the nearest skin color and use its vitiligo as target
   %need to change it to user defined matrix
       %indices_knn1=knnsearch(train_vector_hist,test_vector1,'K',1,'Distance',@ordinal_ds);
        indices_knn1=knnsearch(train_vector_hist,test_vector1,'K',1,'Distance','chebychev');
        I_ori=imread([folder1,imgList_ori(indices_knn1).name]);
        I_GT=imread([folder2,imgList_GT(indices_knn1).name]);
        vitiligo_image=target_region(I_ori,I_GT);
        %imwrite(I_ori,['patch_',num2str(ii),'.png'])
end

