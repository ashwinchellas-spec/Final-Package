function output = RUN_J79_TSFC_REVIEW(modelFile)
%RUN_J79_TSFC_REVIEW Fresh simulator test of TSFC = predicted fuel/predicted thrust.
% Select the existing engine_1/experimental_model.mat. No fitting or DB writes.
% This diagnostic does not replace the prior model or certify real-engine accuracy.
if nargin<1
    [name,folder]=uigetfile('*.mat','Select engine_1 / experimental_model.mat');
    if isequal(name,0), output=[]; return; end
    modelFile=fullfile(folder,name);
end
loaded=load(modelFile,'bundle'); b=loaded.bundle;
assert(strcmp(b.Mode,'EXPERIMENTAL_SIMULATOR_ONLY')&&b.EngineSnapshot.ID==1, ...
    'Select the J79 engine_1 experimental model.');
assert(isequal(b.TargetNames,{'Thrust_N','FuelFlow_kgs','TSFC_kgNs'}),'Unexpected target order.');
oldPath=path; oldRng=rng; cleanup=onCleanup(@() restore_state(oldPath,oldRng)); %#ok<NASGU>
addpath(b.ProjectRoot,genpath(fullfile(b.ProjectRoot,'matlab')),'-begin');
% Inner scope closes the database before the outer scope restores the path.
output=run_review(b,modelFile);
end
function output=run_review(b,modelFile)
p=project_paths(); assert(strcmpi(char(p.root),char(b.ProjectRoot)),'Another project copy is active.');
db=DB_Interface(p.database_file); closeDB=onCleanup(@() delete(db)); %#ok<NASGU>
e=db_get_engine(db,1);
assert(strcmp(e.Fingerprint,b.Fingerprint),'Model source or parameters changed; this model is stale.');
% Predeclared rule, size and seed; no parameter selection on these new points.
seed=17092026; rng(seed,'twister'); n=600;
X=b.Bounds(:,1)'+rand(n,3).*(b.Bounds(:,2)-b.Bounds(:,1))';
Y=NaN(n,3); accepted=false(n,1); notes=strings(n,1);
for i=1:n
    r=simulate_engine(e,flight_condition(X(i,1),X(i,2),X(i,3),'geometric'));
    Y(i,:)=[r.Thrust_N,r.FuelFlow_kgs,r.TSFC_kgNs];
    accepted(i)=r.Valid && all(isfinite(Y(i,:))) && Y(i,1)>0;
    notes(i)=strjoin(string(r.Warnings),' | ');
    if mod(i,120)==0, fprintf('Fresh test: %d/%d points\n',i,n); drawnow; end
end
prediction=ml_apply_candidate(b.Model,X);
ratio=NaN(n,1); available=all(isfinite(prediction(:,1:2)),2)&prediction(:,1)>0&prediction(:,2)>=0;
ratio(available)=prediction(available,2)./prediction(available,1);
folder=tempname(p.reports); mkdir(folder);
rows=array2table([X,Y,prediction,ratio],'VariableNames', ...
    {'Altitude_m','Mach','Throttle','PhysicsThrust_N','PhysicsFuelFlow_kgs','PhysicsTSFC_kgNs', ...
    'MLThrust_N','MLFuelFlow_kgs','DirectTSFC_kgNs','DerivedTSFC_kgNs'});
rows.SimulatorAccepted=accepted; rows.RatioAvailable=available; rows.Warnings=notes;
writetable(rows,fullfile(folder,'fresh_test_predictions.csv'));
assert(nnz(accepted)>=100,'Too few accepted simulator points. See saved predictions.');
% Never silently discard points where the revised predictor fails.
assert(all(available(accepted)), ...
    'Ratio unavailable on accepted simulator points; see saved predictions. No pass is awarded.');
revised=prediction; revised(:,3)=ratio;
baselineMetrics=ml_metrics(Y(accepted,:),prediction(accepted,:),b.TargetNames);
revisedMetrics=ml_metrics(Y(accepted,:),revised(accepted,:),b.TargetNames);
baselineMetrics.Method=repmat("Original independent TSFC fit",3,1);
revisedMetrics.Method=repmat("TSFC from predicted fuel/thrust",3,1);
metrics=[baselineMetrics;revisedMetrics];
metrics.Properties.VariableNames{'MeetsAccuracyCriteria'}='MeetsSimulatorCriteriaOnly';
writetable(metrics,fullfile(folder,'fresh_test_metrics.csv'));
label='EXPERIMENTAL: fresh simulator test only; not manufacturer validation.';
output=struct('Folder',folder,'Metrics',metrics,'Seed',seed,'CandidateCount',n, ...
    'AcceptedCount',nnz(accepted),'RejectedCount',nnz(~accepted), ...
    'SourceModelFile',modelFile,'FrozenSourceBundle',b,'TSFCRule','PredictedFuelFlow_kgs / PredictedThrust_N', ...
    'Label',label,'Operational',false);
save(fullfile(folder,'j79_derived_tsfc_review.mat'),'output','-v7.3');
disp(metrics); fprintf('\n%s\nSaved: %s\n',label,folder);
fprintf('Upload fresh_test_metrics.csv. No existing model was overwritten or retrained.\n');
end
function restore_state(oldPath,oldRng)
path(oldPath); rng(oldRng);
end
