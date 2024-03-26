function output= reinhard_histo(source_channel_lab,target_channel_lab)
%REINHARD_HISTO use histogram matching to transfer 
%   Detailed explanation goes here
%rgb2lab space 
%define Bmin
[x,y]=size(source_channel_lab);
I_s=reshape(source_channel_lab,1,[]);
I_t=reshape(target_channel_lab,1,[]);
B=100;
B_min=10;
S_max=log2(B/B_min);
% for the largest scale
B_largescale=floor(B*2^(1-S_max));
h_output=histogram(I_s,B_largescale,'Normalization','probability');
counts_o=h_output.BinCounts;
sum_counts_o=sum(counts_o)+0.0;
counts_o_norm=counts_o./sum_counts_o;
for k=1:1:S_max
    Bk=floor(B*2^(k-S_max));
    %based on bk to downsample the histogram
    hk_I_t=histogram(I_t,Bk,'Normalization','probability');
    %calculate region
    counts_t=hk_I_t.BinCounts;
    sum_counts_t=sum(counts_t)+0.0;
    counts_t_norm=counts_t./sum_counts_t;
    edges_t=hk_I_t.BinEdges;
    minIndexes = imregionalmin(counts_t);  % Find indexes of local mins in the histogram.
    connectcomp=bwconncomp(minIndexes);
    modi_temp=connectcomp.PixelIdxList;
    len_modi=size(modi_temp,2);
    for test=1:len_modi
        len_num=size(modi_temp{1,test},1);
        if (len_num>1)
            num=modi_temp{1,test};
            for test1=2:len_num
                minIndexes(1,num(test1))=0;
            end
        end
    end
    regionk_number=nnz(minIndexes)-1;
    regionk=find(minIndexes);
    %histogram for source 
    hs_I_k=histogram(I_s,Bk,'Normalization','probability');
    counts_s=hs_I_k.BinCounts;
    sum_counts_s=sum(counts_s)+0.0;
    counts_s_norm=counts_s./sum_counts_s;
    edges_s=hs_I_k.BinEdges;
    %give a random w_s(k)
    w_s(k)=0.5;
    w_t(k)=1-w_s(k);
    for j=1:regionk_number
    a=regionk(j);
    b=regionk(j+1)-1;
    mu_o(k,j)=sum(counts_o_norm(a:b))/(b-a);
    mu_t(k,j)=sum(counts_t_norm(a:b))/(b-a);
    sigma_o(k,j)=0;
    sigma_t(k,j)=0;
    for i=a:b
        sigma_o(k,j)=sigma_o(k,j)+(counts_o_norm(i)-mu_o(k,j))^2;
        sigma_t(k,j)=sigma_t(k,j)+(counts_t_norm(i)-mu_t(k,j))^2;
    end
    sigma_o(k,j)=w_s(k)*sqrt(sigma_o(k,j)/(b-a));
    sigma_t(k,j)=w_t(k)*sqrt(sigma_t(k,j)/(b-a));
    mu_o(k,j)=w_s(k)*mu_o(k,j);
    mu_t(k,j)=w_t(k)*mu_t(k,j);
    %match the histogram in region j
    for i=a:b
        counts_o_norm(i)=counts_o_norm(i)-mu_o(k,j);
        if (sigma_t(k,j)~=0)&&(sigma_o(k,j)~=0)
        counts_o_norm(i)=counts_o_norm(i)*sigma_t(k,j)/sigma_o(k,j)+mu_t(k,j);
        end
    end    
    end
    %reverse the region
    
    minIndexes = imregionalmin(counts_o_norm);  % Find indexes of local mins in the histogram.
    %avoid flat histogram be regard as region
    connectcomp=bwconncomp(minIndexes);
    modi_temp=connectcomp.PixelIdxList;
    len_modi=size(modi_temp,2);
    for test=1:len_modi
        len_num=size(modi_temp{1,test},1);
        if (len_num>1)
            num=modi_temp{1,test};
            for test1=2:len_num
                minIndexes(1,num(test1))=0;
            end
        end
    end
    regions_number=nnz(minIndexes)-1;
    regions=find(minIndexes);
    for j=1:regions_number
    a=regions(j);
    b=regions(j+1)-1;
    mu_o(k,j)=sum(counts_o_norm(a:b))/(b-a);
    mu_t(k,j)=sum(counts_t_norm(a:b))/(b-a);
    sigma_o(k,j)=0;
    sigma_t(k,j)=0;
    for i=a:b
        sigma_o(k,j)=sigma_o(k,j)+(counts_o_norm(i)-mu_o(k,j))^2;
        sigma_t(k,j)=sigma_t(k,j)+(counts_t_norm(i)-mu_t(k,j))^2;
    end
    sigma_o(k,j)=w_s(k)*sqrt(sigma_o(k,j)/(b-a));
    sigma_t(k,j)=w_t(k)*sqrt(sigma_t(k,j)/(b-a));
    mu_o(k,j)=w_s(k)*mu_o(k,j);
    mu_t(k,j)=w_t(k)*mu_t(k,j);
    %match the histogram in region j
    for i=a:b
        counts_o_norm(i)=counts_o_norm(i)-mu_o(k,j);
        if (sigma_t(k,j)~=0)&&(sigma_o(k,j)~=0)
        counts_o_norm(i)=counts_o_norm(i)*sigma_t(k,j)/sigma_o(k,j)+mu_t(k,j);
        end

    end    
    end
%      for neg_num=1:length(counts_o_norm)
%             if counts_o_norm(neg_num)<0
%                 counts_o_norm(neg_num)=0;
%             end
% 
%     end
    sum_counts_on=sum(counts_o_norm)+0.0;
    counts_o_norm=counts_o_norm./sum_counts_on;
    counts_o_norm;
    %histogram('BinEdges',edges_s(1:21),'Bincounts',counts_o_norm)
    %upsample for next
    if k<floor(S_max)
    counts_o_norm=upsample_o(counts_o_norm,2);
    end
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%define the CPF
[a,b]=size(counts_o_norm);
C_s=zeros(a,b);
C_s(1,1)=counts_s_norm(1,1);
C_o=zeros(a,b);
C_o(1,1)=counts_o_norm(1,1);
for i=2:1:b
    C_s(1,i)=C_s(1,i-1)+counts_s_norm(1,i);
    C_o(1,i)=C_o(1,i-1)+counts_o_norm(1,i);
end
test=1; %end
I_min=min(reshape(source_channel_lab,1,[]));
v=edges_s(1,2)-edges_s(1,1);
for i=1:x
    for j=1:y
        Idx=floor((source_channel_lab(i,j)-I_min)/v)+1;
        value=C_s(Idx);
            num1=find(value<=C_o,1,'first');
            TF=isempty(num1);
            if TF
                output(i,j)=edges_t(end);
            else
        output(i,j)=(edges_t(num1)+edges_t(num1+1))/2;
            end
    end
end
            
        
        
        
        



