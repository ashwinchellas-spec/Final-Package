function result=START_J79_PREDICTIONS(reviewFile)
%START_J79_PREDICTIONS Make a separate reviewed experimental J79 prediction bundle.
% Open the saved j79_derived_tsfc_review.mat from the successful 600-point run.
% No retraining, database change, or operational-model acceptance occurs.
if nargin<1
    [name,folder]=uigetfile('j79_derived_tsfc_review.mat', ...
        'Select j79_derived_tsfc_review.mat from the successful fresh test');
    if isequal(name,0), fprintf('Cancelled. No changes made.\n'); result=[]; return; end
    reviewFile=fullfile(folder,name);
end
s=load(reviewFile,'output'); audit=s.output; b=audit.FrozenSourceBundle;
assert(b.EngineSnapshot.ID==1 && strcmp(b.Mode,'EXPERIMENTAL_SIMULATOR_ONLY') && ~b.Operational, ...
    'Choose the J79 experimental review artifact.');
assert(strcmp(audit.TSFCRule,'PredictedFuelFlow_kgs / PredictedThrust_N'), ...
    'Unexpected reviewed TSFC rule.');
assert(audit.AcceptedCount==600 && audit.CandidateCount==600 && audit.RejectedCount==0, ...
    'This integration expects the completed 600-point review.');
m=audit.Metrics(string(audit.Metrics.Method)=="TSFC from predicted fuel/thrust",:);
assert(height(m)==3 && isequal(cellstr(string(m.Target)),b.TargetNames(:)), ...
    'Review target schema does not match the saved model.');
passed=isfinite(m.R2)&m.R2>=.95 & m.RelativeRMSE<.02 & m.RelativeMAE<.015 & m.MAPE_Percent<5;
assert(all(passed),'The reviewed predictor does not meet all simulator criteria.');
oldPath=path; cleanup=onCleanup(@() path(oldPath)); %#ok<NASGU>
addon=fileparts(mfilename('fullpath'));
addpath(b.ProjectRoot,genpath(fullfile(b.ProjectRoot,'matlab')),'-begin');
addpath(addon,'-begin');
assert(strcmp(which('PREDICT_EXPERIMENTAL_ML'),fullfile(addon,'PREDICT_EXPERIMENTAL_ML.m')), ...
    'Another prediction helper is active. Set Current Folder to this integration folder.');
p=project_paths(); assert(strcmpi(char(p.root),char(b.ProjectRoot)),'Another project copy is active.');
% Preserve original evidence and make the change explicit. Model coefficients stay fixed.
b.OriginalTestMetrics=b.TestMetrics;
b.TestMetrics=m;
b.TSFCMethod='PredictedFuelDividedByPredictedThrust';
b.IntegrationVersion='J79-TSFC-RATIO-1';
b.ReviewEvidence=audit;
b.Label='EXPERIMENTAL J79 simulator surrogate; derived TSFC passed a 600-point fresh simulation test; not manufacturer validation.';
% Old raw timing was for the independent fit; do not present it as revised timing.
b.OriginalRawPredictionSeconds=b.RawPredictionSeconds;
b.RawPredictionSeconds=NaN;
b.Operational=false;
folder=tempname(p.reports); mkdir(folder);
bundle=b; modelFile=fullfile(folder,'j79_reviewed_model.mat');
save(modelFile,'bundle','-v7.3');
% This helper also checks current source/parameter fingerprints and simulator validity.
X=[0,.3,1;5000,.3,1;10000,.3,1];
samples=PREDICT_EXPERIMENTAL_ML(modelFile,X);
assert(all(samples.PredictionAvailable),'A sample was rejected; inspect the current source and model bounds.');
relativeResidual=abs(samples.TSFC_kgNs-samples.FuelFlow_kgs./samples.Thrust_N) ...
    ./max(abs(samples.TSFC_kgNs),eps);
assert(all(relativeResidual<1e-12),'Derived TSFC identity check failed.');
writetable(samples,fullfile(folder,'sample_predictions.csv'));
writetable(m,fullfile(folder,'retained_fresh_test_metrics.csv'));
result=struct('Folder',folder,'ModelFile',modelFile,'Samples',samples, ...
    'Status','EXPERIMENTAL_ONLY','ReviewFile',reviewFile);
save(fullfile(folder,'integration_result.mat'),'result');
disp(samples);
fprintf('\nReviewed J79 prediction bundle saved. No retraining was needed.\n%s\n',modelFile);
fprintf('Experimental prediction only; manufacturer validation remains incomplete.\n');
end
