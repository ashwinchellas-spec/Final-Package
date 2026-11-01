function [features,powers] = ml_polynomial_features(X,degree,powers)
%ML_POLYNOMIAL_FEATURES Complete monomial basis up to a total degree, including bias.
% Inputs: standardised predictors, degree, optional fitted powers. Output: matrix/basis.
% Units: dimensionless. Deterministic; no external polyfitn dependency.
if nargin<3
    validateattributes(degree,{'numeric'},{'scalar','integer','>=',1,'<=',5});
    if size(X,2)~=3, error('ABACUS:MLFeatures','Exactly three predictors are required.'); end
    powers=zeros(0,3);
    for a=0:degree
        for b=0:degree-a
            for c=0:degree-a-b, powers(end+1,:)=[a,b,c]; end %#ok<AGROW>
        end
    end
end
features=ones(size(X,1),size(powers,1));
for j=1:size(powers,1), features(:,j)=prod(X.^powers(j,:),2); end
end
