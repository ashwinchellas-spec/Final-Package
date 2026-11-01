function Y=BOUNDARY_MODEL_VALUES(model,X)
%BOUNDARY_MODEL_VALUES Evaluate a frozen two-output model, then derive TSFC.
P=ml_apply_candidate(model.Core,X);
if model.LogTargets, P=exp(P); end
Y=[P,NaN(size(X,1),1)];
valid=all(isfinite(P),2)&P(:,1)>0&P(:,2)>=0;
Y(valid,3)=P(valid,2)./P(valid,1);
end
