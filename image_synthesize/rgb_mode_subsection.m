function [r_v_mode,g_v_mode,b_v_mode] = rgb_mode_subsection(input_image)
%RGB_MODE_SUBSECTION Summary of this function goes here
%   Detailed explanation goes here
% vitiligo skin
redchannel=input_image(:,:,1);
greenchannel=input_image(:,:,2);
bluechannel=input_image(:,:,3);
skin_region=redchannel>0&greenchannel>0&bluechannel>0;
edges=linspace(0,255,51);
R_vskin=redchannel(skin_region);
G_vskin=greenchannel(skin_region);
B_vskin=bluechannel(skin_region);
R_V=reshape(R_vskin,[],1);
G_V=reshape(G_vskin,[],1);
B_V=reshape(B_vskin,[],1);
hist_R_V=histogram(R_V,edges);
R_vector_V=hist_R_V.Values;
hist_G_V=histogram(G_V,edges);
G_vector_V=hist_G_V.Values;
hist_B_V=histogram(B_V,edges);
B_vector_V=hist_B_V.Values;
max_R_V=max(R_vector_V);
[~,col_rv]=find(R_vector_V==max_R_V);
idx_R_V=col_rv(1,1);
r_v_mode=(edges(idx_R_V)+edges(idx_R_V+1))/2;
max_G_V=max(G_vector_V);
[~,col_gv]=find(G_vector_V==max_G_V);
idx_G_V=col_gv(1,1);
g_v_mode=(edges(idx_G_V)+edges(idx_G_V+1))/2;
max_B_V=max(B_vector_V);
[~,col_bv]=find(B_vector_V==max_B_V);
idx_B_V=col_bv(1,1);
b_v_mode=(edges(idx_B_V)+edges(idx_B_V+1))/2;
end

