function data = ml_generate_dataset(dt,engineID)
%ML_GENERATE_DATASET Generate synthetic data only after current physics acceptance.
% Inputs: DT coordinator and engine ID. Output: dataset struct and MAT/CSV artifacts.
% Ref: ABACUS 20. Invalid grid rows retained separately; only valid rows enter training.
e=db_get_engine(dt.Database,engineID); certificate=require_validation(e);
grid=performance_grid(e); allRows=dt.map(engineID,false); targets=ml_targets(e.Type); c=project_config();
valid=logical(allRows.Valid) & all(isfinite(allRows{:,targets}),2);
t=allRows(valid,:); X=t{:,c.MLFeatures}; Y=t{:,targets};
split=ml_stratified_split(X,c.RandomSeed);
data=struct('Label','Physics-generated synthetic data','Engine_ID',e.ID,'Engine',e.Name,...
    'Architecture',e.Type,'Confidence',e.Confidence,'Fingerprint',e.Fingerprint,...
    'ModelVersion',c.Version,'FeatureNames',{c.MLFeatures},'TargetNames',{targets},...
    'X',X,'Y',Y,'Split',split,'Grid',grid,'ValidityMask',reshape(valid,[numel(grid.Altitude_m),numel(grid.Mach),numel(grid.Throttle)]),...
    'ValidationCertificate',certificate,'Timestamp_UTC',utc_timestamp());
p=project_paths(); folder=fullfile(p.results,'ml_datasets'); if ~isfolder(folder), mkdir(folder); end
save(fullfile(folder,sprintf('engine_%d_dataset.mat',e.ID)),'data','-v7.3');
writetable(t,fullfile(folder,sprintf('engine_%d_synthetic.csv',e.ID)));
writetable(allRows(~valid,:),fullfile(folder,sprintf('engine_%d_rejected.csv',e.ID)));
end
