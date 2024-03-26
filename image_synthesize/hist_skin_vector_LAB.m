function hist_vector = hist_skin_vector_LAB(input_image)
%This function will return the normalized histogram of the input image
%more than 200 is vitiligo marker
redchannel=input_image(:,:,1);
greenchannel=input_image(:,:,2);
bluechannel=input_image(:,:,3);
nskin_region=redchannel>0|greenchannel>0|bluechannel>0;

%lab space range is [-100,100]
edges=linspace(-100,100,101);
lab=rgb2lab(uint8(input_image));
l_channel=lab(:,:,1);
a_channel=lab(:,:,2);
b_channel=lab(:,:,3);
l_nskin=l_channel(nskin_region);
l=reshape(l_nskin,[],1);
a_nskin=a_channel(nskin_region);
a=reshape(a_nskin,[],1);
b_nskin=b_channel(nskin_region);
b=reshape(b_nskin,[],1);
hist_I=histogram(l,edges);
I_vector=hist_I.Values;
hist_a=histogram(a,edges);
a_vector=hist_a.Values;
hist_b=histogram(b,edges);
b_vector=hist_b.Values;
sum_I=sum(I_vector);
sum_a=sum(a_vector);
sum_b=sum(b_vector);
I_vector_nor=I_vector./sum_I;
a_vector_nor=a_vector./sum_a;
b_vector_nor=b_vector./sum_b;
hist_vector=horzcat(I_vector_nor,a_vector_nor,b_vector_nor);

