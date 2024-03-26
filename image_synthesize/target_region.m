function vitiligo_color= target_region(I_ori,I_GT)
%TARGET_REGION Summary of this function goes here
%   Detailed explanation goes here
%RGB_MODE-> returns the RGB color mode for normal skin and vitiligo
redchannel=I_GT(:,:,1);
greenchannel=I_GT(:,:,2);
bluechannel=I_GT(:,:,3);
vskin_region=redchannel>200&greenchannel>200&bluechannel>200;
% vitiligo skin
redchannel_n=I_ori(:,:,1);
greenchannel_n=I_ori(:,:,2);
bluechannel_n=I_ori(:,:,3);
R_vskin=redchannel_n(vskin_region);
G_vskin=greenchannel_n(vskin_region);
B_vskin=bluechannel_n(vskin_region);
vitiligo_color=cat(3,R_vskin,G_vskin,B_vskin);
end
