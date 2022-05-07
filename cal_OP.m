function [OP] = cal_OP(array,CDF,threshold)
%ALG_OP 此处显示有关此函数的摘要
%   此处显示详细说明
% n=length(threshold);
% OP=zeros(1,n);
% for i=1:n
% th=find(array<threshold);
%     if isempty(th)
%         OP=0;
%     else
%         OP=CDF(th(end)); 
%     end
%     OP=roundn(OP,-2); 
% end
index = [];
 Accuracy = 0.001;
        while(isempty(index))
            index = find(abs(array-threshold)<=Accuracy);
            Accuracy = 3*Accuracy;
        end
        OP = CDF(index(1));


end

