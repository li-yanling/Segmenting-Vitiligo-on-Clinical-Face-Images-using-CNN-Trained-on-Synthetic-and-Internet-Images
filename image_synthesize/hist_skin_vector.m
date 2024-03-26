function hist_vector = hist_skin_vector(input_image)
%This function will return the normalized histogram of the input image
%more than 200 is vitiligo marker
redchannel=input_image(:,:,1);
greenchannel=input_image(:,:,2);
bluechannel=input_image(:,:,3);
nskin_region=redchannel>0|greenchannel>0|bluechannel>0;

edges=linspace(0,255,51);
R_nskin=redchannel(nskin_region);
R=reshape(R_nskin,[],1);
G_nskin=greenchannel(nskin_region);
G=reshape(G_nskin,[],1);
B_nskin=bluechannel(nskin_region);
B=reshape(B_nskin,[],1);
hist_R=histogram(R,edges);
R_vector=hist_R.Values;
hist_G=histogram(G,edges);
G_vector=hist_G.Values;
hist_B=histogram(B,edges);
B_vector=hist_B.Values;
sum_R=sum(R_vector);
sum_G=sum(G_vector);
sum_B=sum(B_vector);
R_vector_nor=R_vector./sum_R;
G_vector_nor=G_vector./sum_G;
B_vector_nor=B_vector./sum_B;
hist_vector=horzcat(R_vector_nor,G_vector_nor,B_vector_nor);