function Y=J79_CHEB_VALUES(model,X)
%J79_CHEB_VALUES Frozen Chebyshev regression, input [altitude_m Mach throttle].
Z=2*(X-model.Bounds(:,1)')./(model.Bounds(:,2)-model.Bounds(:,1))'-1;
d=double(model.Degree); q=cell(3,1);
for j=1:3
    T=ones(size(X,1),d+1); T(:,2)=Z(:,j);
    for k=2:d, T(:,k+1)=2*Z(:,j).*T(:,k)-T(:,k-1); end
    q{j}=T;
end
p=double(model.Powers)+1;
A=q{1}(:,p(:,1)).*q{2}(:,p(:,2)).*q{3}(:,p(:,3));
P=(A*model.Coefficients).*model.OutputScale+model.OutputMean;
Y=[P,NaN(size(X,1),1)]; ok=all(isfinite(P),2)&P(:,1)>0&P(:,2)>=0;
Y(ok,3)=P(ok,2)./P(ok,1);
end
