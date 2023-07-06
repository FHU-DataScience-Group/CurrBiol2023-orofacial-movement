function [Score,W,D,M] = fastPCA(X)
%FASTPCA Summary of this function goes here
%   Detailed explanation goes here

M=mean(X,1);
Y=X-repmat(M,[size(X,1),1]);
[~,S,W]=svd(Y,'econ');
Score=Y*W;
D=diag(S).^2/size(X,1);

end
