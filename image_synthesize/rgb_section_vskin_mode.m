function [V_R_mode,V_G_mode,V_B_mode] = rgb_section_vskin_mode(image_section1,image_section2,image_section3,image_section4,imgList_ori,imgList_GT,train_vector_hist,folder1,folder2)
%RGB_SECTION_VSKIN_MODE Summary of this function goes here
%   calculate the mapped vitiligy skin mode as the input for interpolation
%image1
    test_vector1=hist_skin_vector(image_section1);
   %test_vector=hist_nskin_vector_RGB_GT(test_image);
    nearest_num=30;
    indices_knn1=knnsearch(train_vector_hist,test_vector1,'K',nearest_num,'Distance','euclidean');
    %mapping for each group
    r_n=zeros(nearest_num,1);
    r_v=zeros(nearest_num,1);
    g_n=zeros(nearest_num,1);
    g_v=zeros(nearest_num,1);
    b_n=zeros(nearest_num,1);
    b_v=zeros(nearest_num,1);
    j=1;
    for jj=1:nearest_num
        I_ori=imread([folder1,imgList_ori(indices_knn1(j,jj)).name]);
        I_GT=imread([folder2,imgList_GT(indices_knn1(j,jj)).name]);
        [r_n(jj),r_v(jj),g_n(jj),g_v(jj),b_n(jj),b_v(jj)]=rgb_mode(I_ori,I_GT);
    end
    %[m_r(j),b_r(j),m_g(j),b_g(j),m_b(j),b_b(j)]=rgb_fit(r_n,r_v,g_n,g_v,b_n,b_v);
    [r1,r2,r3,rb,g1,g2,g3,gb,b1,b2,b3,bb] = rgb_regression(nearest_num,r_n,r_v,g_n,g_v,b_n,b_v);
    %Map the color in the specific location with the specific cluster mapping informaiton 
    %output=mapping_knn(test_image,[col_final,row_final],1,m_r,b_r,m_g,b_g,m_b,b_b);
    output1=mapping_for_subregion(image_section1,r1,r2,r3,rb,g1,g2,g3,gb,b1,b2,b3,bb);
     [r_v_mode1,g_v_mode1,b_v_mode1] = rgb_mode_subsection(output1);
     %image2
     test_vector2=hist_skin_vector(image_section2);
     indices_knn2=knnsearch(train_vector_hist,test_vector2,'K',nearest_num,'Distance','euclidean');
    %mapping for each group
    r_n=zeros(nearest_num,1);
    r_v=zeros(nearest_num,1);
    g_n=zeros(nearest_num,1);
    g_v=zeros(nearest_num,1);
    b_n=zeros(nearest_num,1);
    b_v=zeros(nearest_num,1);
    j=1;
    for jj=1:nearest_num
        I_ori=imread([folder1,imgList_ori(indices_knn2(j,jj)).name]);
        I_GT=imread([folder2,imgList_GT(indices_knn2(j,jj)).name]);
        [r_n(jj),r_v(jj),g_n(jj),g_v(jj),b_n(jj),b_v(jj)]=rgb_mode(I_ori,I_GT);
    end
    %[m_r(j),b_r(j),m_g(j),b_g(j),m_b(j),b_b(j)]=rgb_fit(r_n,r_v,g_n,g_v,b_n,b_v);
    [r1,r2,r3,rb,g1,g2,g3,gb,b1,b2,b3,bb] = rgb_regression(nearest_num,r_n,r_v,g_n,g_v,b_n,b_v);
    %Map the color in the specific location with the specific cluster mapping informaiton 
    %output=mapping_knn(test_image,[col_final,row_final],1,m_r,b_r,m_g,b_g,m_b,b_b);
    output2=mapping_for_subregion(image_section2,r1,r2,r3,rb,g1,g2,g3,gb,b1,b2,b3,bb);
     [r_v_mode2,g_v_mode2,b_v_mode2] = rgb_mode_subsection(output2);
     %image 3
     test_vector3=hist_skin_vector(image_section3);
     indices_knn3=knnsearch(train_vector_hist,test_vector3,'K',nearest_num,'Distance','euclidean');
    %mapping for each group
    r_n=zeros(nearest_num,1);
    r_v=zeros(nearest_num,1);
    g_n=zeros(nearest_num,1);
    g_v=zeros(nearest_num,1);
    b_n=zeros(nearest_num,1);
    b_v=zeros(nearest_num,1);
    j=1;
    for jj=1:nearest_num
        I_ori=imread([folder1,imgList_ori(indices_knn3(j,jj)).name]);
        I_GT=imread([folder2,imgList_GT(indices_knn3(j,jj)).name]);
        [r_n(jj),r_v(jj),g_n(jj),g_v(jj),b_n(jj),b_v(jj)]=rgb_mode(I_ori,I_GT);
    end
    %[m_r(j),b_r(j),m_g(j),b_g(j),m_b(j),b_b(j)]=rgb_fit(r_n,r_v,g_n,g_v,b_n,b_v);
    [r1,r2,r3,rb,g1,g2,g3,gb,b1,b2,b3,bb] = rgb_regression(nearest_num,r_n,r_v,g_n,g_v,b_n,b_v);
    %Map the color in the specific location with the specific cluster mapping informaiton 
    %output=mapping_knn(test_image,[col_final,row_final],1,m_r,b_r,m_g,b_g,m_b,b_b);
    output3=mapping_for_subregion(image_section3,r1,r2,r3,rb,g1,g2,g3,gb,b1,b2,b3,bb);
     [r_v_mode3,g_v_mode3,b_v_mode3] = rgb_mode_subsection(output3);
     %image 4
    test_vector4=hist_skin_vector(image_section4);
    indices_knn4=knnsearch(train_vector_hist,test_vector4,'K',nearest_num,'Distance','euclidean');
    %mapping for each group
    r_n=zeros(nearest_num,1);
    r_v=zeros(nearest_num,1);
    g_n=zeros(nearest_num,1);
    g_v=zeros(nearest_num,1);
    b_n=zeros(nearest_num,1);
    b_v=zeros(nearest_num,1);
    j=1;
    for jj=1:nearest_num
        I_ori=imread([folder1,imgList_ori(indices_knn4(j,jj)).name]);
        I_GT=imread([folder2,imgList_GT(indices_knn4(j,jj)).name]);
        [r_n(jj),r_v(jj),g_n(jj),g_v(jj),b_n(jj),b_v(jj)]=rgb_mode(I_ori,I_GT);
    end
    %[m_r(j),b_r(j),m_g(j),b_g(j),m_b(j),b_b(j)]=rgb_fit(r_n,r_v,g_n,g_v,b_n,b_v);
    [r1,r2,r3,rb,g1,g2,g3,gb,b1,b2,b3,bb] = rgb_regression(nearest_num,r_n,r_v,g_n,g_v,b_n,b_v);
    %Map the color in the specific location with the specific cluster mapping informaiton 
    %output=mapping_knn(test_image,[col_final,row_final],1,m_r,b_r,m_g,b_g,m_b,b_b);
    output4=mapping_for_subregion(image_section4,r1,r2,r3,rb,g1,g2,g3,gb,b1,b2,b3,bb);
     [r_v_mode4,g_v_mode4,b_v_mode4] = rgb_mode_subsection(output4);
V_R_mode=[r_v_mode1,r_v_mode2;r_v_mode3,r_v_mode4];
V_G_mode=[g_v_mode1,g_v_mode2;g_v_mode3,g_v_mode4];
V_B_mode=[b_v_mode1,b_v_mode2;b_v_mode3,b_v_mode4];
end

