function summary = ml_train_surrogates(dt,engineID,data)
%ML_TRAIN_SURROGATES Fit four families, select using validation, then unlock test set.
% Inputs: DT, engine ID, optional validated dataset. Output: actual metrics and MAT artifacts.
% Ref: ABACUS 20; rng(42). No fabricated pretrained models or target accuracy claims.
e=db_get_engine(dt.Database,engineID); require_validation(e);
if nargin<3, data=ml_generate_dataset(dt,engineID); end
if ~strcmp(data.Fingerprint,e.Fingerprint), error('ABACUS:StaleDataset','Dataset does not match the current physics/provenance.'); end
if ~license('test','Statistics_Toolbox'), error('ABACUS:MLToolbox','Statistics and Machine Learning Toolbox is required.'); end
p=project_paths(); old=rng; clean=onCleanup(@() rng(old)); rng(42,'twister');
train=data.Split.Train; val=data.Split.Validation; test=data.Split.Test;
families={'Poly','RF','GPR','ANN'}; selected=cell(4,1); valScores=inf(4,1); diagnostics=cell(0,1);
for i=1:4
    for setting=1:2
        model=ml_fit_candidate(data.X(train,:),data.Y(train,:),families{i},setting);
        prediction=ml_apply_candidate(model,data.X(val,:));
        metrics=ml_metrics(data.Y(val,:),prediction,data.TargetNames);
        score=mean(metrics.RelativeRMSE);
        item=metrics; item.Family=repmat(string(families{i}),height(item),1); item.Setting=repmat(setting,height(item),1);
        diagnostics{end+1,1}=item; %#ok<AGROW>
        if score<valScores(i), valScores(i)=score; selected{i}=model; end
    end
end
% Family choice is frozen using validation loss BEFORE test metrics are inspected.
[~,winner]=min(valScores); evaluations=cell(4,1);
for i=1:4
    model=selected{i}; predictions=ml_apply_candidate(model,data.X(test,:));
    metrics=ml_metrics(data.Y(test,:),predictions,data.TargetNames);
    start=tic;
    for query=1:1000, ml_apply_candidate(model,data.X(find(test,1),:)); end
    latency=toc(start)*1000/1000; metrics.Prediction_ms=repmat(latency,height(metrics),1);
    metrics.Family=repmat(string(families{i}),height(metrics),1); metrics.Selected=repmat(i==winner,height(metrics),1);
    bundle=struct('Model',model,'Engine_ID',e.ID,'Engine',e.Name,'Architecture',e.Type,...
        'Fingerprint',e.Fingerprint,'TargetNames',{data.TargetNames},'FeatureNames',{data.FeatureNames},...
        'Grid',data.Grid,'ValidityMask',data.ValidityMask,'TestMetrics',metrics,...
        'ValidationScore',valScores(i),'ActualSplit',data.Split.ActualFractions,...
        'Operational',all(metrics.MeetsAccuracyCriteria)&&latency<10,...
        'Label','Surrogate of physics-generated synthetic data; not measured engine data.',...
        'Timestamp_UTC',utc_timestamp());
    save(fullfile(p.ml_models,sprintf('engine_%d_%s.mat',e.ID,families{i})),'bundle','-v7.3');
    if i==winner
        save(fullfile(p.ml_models,sprintf('engine_%d_best.mat',e.ID)),'bundle','-v7.3');
        ml_diagnostic_report(data,predictions,metrics,e.ID);
    end
    evaluations{i}=metrics;
end
summary=vertcat(evaluations{:}); writetable(summary,fullfile(p.reports,sprintf('engine_%d_track_b.csv',e.ID)));
writetable(vertcat(diagnostics{:}),fullfile(p.reports,sprintf('engine_%d_validation_selection.csv',e.ID)));
end
