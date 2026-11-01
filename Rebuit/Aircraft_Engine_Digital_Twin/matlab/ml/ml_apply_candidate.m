function Y = ml_apply_candidate(model,X)
%ML_APPLY_CANDIDATE Predict with stored training scales; never refit on query data.
% Inputs: fitted candidate, n-by-3 SI features. Output: n-by-target SI predictions.
% Prediction errors propagate to the coordinator's physics fallback.
Z=(X-model.Mu)./model.Sigma; Y=zeros(size(X,1),numel(model.Objects));
for j=1:numel(model.Objects)
    object=model.Objects{j};
    if strcmp(model.Family,'Poly')
        A=ml_polynomial_features(Z,object.Degree,object.Powers); pred=A*object.Beta;
    else
        pred=predict(object,Z);
    end
    Y(:,j)=double(pred)*model.YSigma(j)+model.YMu(j);
end
end
