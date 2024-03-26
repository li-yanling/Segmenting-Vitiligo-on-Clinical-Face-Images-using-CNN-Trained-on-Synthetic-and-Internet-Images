function [r1,r2,r3,rb,g1,g2,g3,gb,b1,b2,b3,bb] = rgb_regression(nearest_num,r_n,r_v,g_n,g_v,b_n,b_v)
%RGB_REGRESSION Summary of this function goes here
%   Detailed explanation goes here
I_const=ones(nearest_num,1);
X=[r_n,g_n,b_n,I_const];
r_out = regress(r_v,X);
g_out = regress(g_v,X);
b_out = regress(b_v,X);
r1=r_out(1,1);
r2=r_out(2,1);
r3=r_out(3,1);
rb=r_out(4,1);

g1=g_out(1,1);
g2=g_out(2,1);
g3=g_out(3,1);
gb=g_out(4,1);

b1=b_out(1,1);
b2=b_out(2,1);
b3=b_out(3,1);
bb=b_out(4,1);
end

