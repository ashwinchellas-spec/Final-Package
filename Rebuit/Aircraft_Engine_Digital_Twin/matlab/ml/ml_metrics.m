function t = ml_metrics(reference,predicted,names)
%ML_METRICS Track B metrics against held-out physics values, not engine measurements.
% Inputs: matching numeric matrices, output names. Output: table, target-specific SI errors.
% MAPE excludes true zeros and reports count. R2 is NaN for a constant target.
if ~isequal(size(reference),size(predicted)), error('ABACUS:MetricShape','Prediction/reference dimensions differ.'); end
parts=cell(size(reference,2),1);
for j=1:size(reference,2)
    y=reference(:,j); p=predicted(:,j);
    if any(~isfinite(y)|~isfinite(p)), error('ABACUS:MetricFinite','Metrics require finite values.'); end
    errorValue=p-y; rmse=sqrt(mean(errorValue.^2)); mae=mean(abs(errorValue)); total=sum((y-mean(y)).^2);
    if total<=eps(max(1,sum(y.^2))), r2=NaN; else, r2=1-sum(errorValue.^2)/total; end
    nonzero=abs(y)>1e-12*max(1,max(abs(y)));
    if any(nonzero), mape=100*mean(abs(errorValue(nonzero)./y(nonzero))); else, mape=NaN; end
    scale=mean(abs(y)); nrmse=rmse/max(scale,eps); nmae=mae/max(scale,eps);
    accepted=isfinite(r2)&&r2>=.95&&nrmse<.02&&nmae<.015&&mape<5;
    parts{j}=table(string(names{j}),r2,rmse,mae,mape,nrmse,nmae,nnz(nonzero),accepted,...
        'VariableNames',{'Target','R2','RMSE','MAE','MAPE_Percent','RelativeRMSE','RelativeMAE','MAPE_Count','MeetsAccuracyCriteria'});
end
t=vertcat(parts{:});
end
