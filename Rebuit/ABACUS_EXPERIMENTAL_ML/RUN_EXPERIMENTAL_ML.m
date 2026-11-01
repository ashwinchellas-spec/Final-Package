function output = RUN_EXPERIMENTAL_ML(projectRoot,engineIDs,sampleCount,families)
%RUN_EXPERIMENTAL_ML Separate academic surrogate experiment, not certification.
% Run with no arguments and choose the existing project folder.
% Optional: RUN_EXPERIMENTAL_ML(root,[9 10 11],720,{'Poly','RF','GPR','ANN'})
% Does not call or alter require_validation, operational models or database data.
if nargin<1 || isempty(projectRoot)
    projectRoot=uigetdir(pwd,'Select Aircraft_Engine_Digital_Twin containing START_HERE.m');
    if isequal(projectRoot,0), output=[]; return; end
end
if nargin<2, engineIDs=[]; end
if nargin<3, sampleCount=720; end
if nargin<4, families={'Poly','RF'}; end
validateattributes(sampleCount,{'numeric'},{'scalar','integer','>=',200});
if isstring(families), families=cellstr(families); end
assert(iscell(families)&&~isempty(families),'Specify at least one model family.');
for k=1:numel(families)
    families{k}=validatestring(families{k},{'Poly','RF','GPR','ANN'});
end
assert(isfile(fullfile(projectRoot,'START_HERE.m')),'Choose the project folder containing START_HERE.m.');
oldPath=path; oldRng=rng;
restore=onCleanup(@() restore_state(oldPath,oldRng)); %#ok<NASGU>
addpath(projectRoot,genpath(fullfile(projectRoot,'matlab')),'-begin');
p=project_paths();
assert(strcmpi(char(p.root),char(projectRoot)), ...
    'Another project copy is active. Set Current Folder to this add-on folder, then retry.');
if any(~strcmp(families,'Poly')) && ~license('test','Statistics_Toolbox')
    error('ABACUS:Toolbox','Statistics and Machine Learning Toolbox is required for RF/GPR/ANN. Use {''Poly''} for base MATLAB.');
end
if ~isfolder(p.reports), mkdir(p.reports); end
folder=tempname(p.reports); mkdir(folder);
label='EXPERIMENTAL: surrogate of unvalidated simulation; not manufacturer performance.';
write_text(fullfile(folder,'READ_ME.txt'),sprintf('%s\nNo validation certificate or operational model is created.\n',label));
% Inner function must finish closing its DB before this outer scope restores path.
output=run_batch(p,engineIDs,sampleCount,families,folder,label);
end

function output=run_batch(p,engineIDs,sampleCount,families,folder,label)
db=DB_Interface(p.database_file); closeDB=onCleanup(@() delete(db)); %#ok<NASGU>
cat=db.read('Engines');
if isempty(engineIDs), engineIDs=cat.Engine_ID(:)'; end
validateattributes(engineIDs,{'numeric'},{'vector','integer','positive','finite'});
engineIDs=unique(engineIDs,'stable');
assert(all(ismember(engineIDs,cat.Engine_ID)),'An engine ID is absent from the catalogue.');
summary=table(); allMetrics=table();
fprintf('\n%s\nOutput folder: %s\n',label,folder);
for index=1:numel(engineIDs)
    id=engineIDs(index); engineFolder=fullfile(folder,sprintf('engine_%d',id)); mkdir(engineFolder);
    fprintf('\nEngine %d/%d (ID %d): generating %d points...\n',index,numel(engineIDs),id,sampleCount); drawnow;
    try
        e=db_get_engine(db,id); rng(4200+id,'twister');
        [row,metrics]=train_one(e,sampleCount,families,engineFolder,label);
        if isempty(allMetrics), allMetrics=metrics; else, allMetrics=[allMetrics;metrics]; end %#ok<AGROW>
    catch exception
        write_text(fullfile(engineFolder,'ERROR.txt'),getReport(exception,'extended','hyperlinks','off'));
        row=table(id,"", "FAILED", "",0,0,0,0,NaN,NaN,string(exception.message), ...
            'VariableNames',{'Engine_ID','Engine','Status','SelectedFamily','TrainRows','ValidationRows','TestRows','RejectedRows','MeanRelativeRMSE','RawPredictionSpeedup','Diagnostic'});
        fprintf('FAILED ID %d: %s\n',id,exception.message);
    end
    if isempty(summary), summary=row; else, summary=[summary;row]; end %#ok<AGROW>
    writetable(summary,fullfile(folder,'SUMMARY.csv'));
    if ~isempty(allMetrics), writetable(allMetrics,fullfile(folder,'TEST_METRICS.csv')); end
end
output=struct('Folder',folder,'Summary',summary,'TestMetrics',allMetrics,'Label',label);
save(fullfile(folder,'EXPERIMENTAL_RUN.mat'),'output');
disp(summary); fprintf('\nCompleted %d/%d engines. Results: %s\n',nnz(summary.Status=="TRAINED"),height(summary),folder);
fprintf('Send SUMMARY.csv and TEST_METRICS.csv. TRAINED does not mean accurate or validated.\n');
end

function [row,metrics]=train_one(e,n,families,folder,label)
% Independent random conditions; split before scaling or model selection.
bounds=[0,min(15000,e.Params.MaxAltitude_m);0,min(2,e.Params.MaxMach);.5,1];
assert(all(isfinite(bounds(:)))&&all(bounds(:,2)>bounds(:,1)),'Invalid sampling bounds.');
X=bounds(:,1)'+rand(n,3).*(bounds(:,2)-bounds(:,1))';
if ismember(e.Type,{'Turboprop','Piston'})
    targets={'ShaftPower_kW','FuelFlow_kgs','BSFC_kgkWh'};
else
    targets={'Thrust_N','FuelFlow_kgs','TSFC_kgNs'};
end
seaLevel=simulate_engine(e,flight_condition(0,0,1,'geometric'));
if ismember(e.Type,{'Turboprop','Piston'})
    rating=e.Params.Rated_Power_kW; value=seaLevel.ShaftPower_kW; unit="kW";
else
    rating=e.Params.Rated_Thrust_N; value=seaLevel.Thrust_N; unit="N";
end
ratingError=100*abs(value-rating)/abs(rating);
comparison=table(e.ID,string(e.Name),value,rating,ratingError,unit, ...
    "Catalogue comparison only; rating conditions and source applicability need review", ...
    'VariableNames',{'Engine_ID','Engine','SimulatedValue','CatalogueValue','ErrorPercent','Unit','Caveat'});
writetable(comparison,fullfile(folder,'catalogue_comparison.csv'));
Y=NaN(n,3); valid=false(n,1); notes=strings(n,1);
for i=1:n
    r=simulate_engine(e,flight_condition(X(i,1),X(i,2),X(i,3),'geometric'));
    Y(i,:)=[r.(targets{1}),r.(targets{2}),r.(targets{3})];
    valid(i)=r.Valid && all(isfinite(Y(i,:)));
    notes(i)=strjoin(string(r.Warnings),' | ');
    if mod(i,120)==0, fprintf('  Simulated %d/%d\n',i,n); drawnow; end
end
indices=find(valid); count=numel(indices);
assert(count>=150,'Only %d valid points; at least 150 are required.',count);
order=indices(randperm(count)); a=floor(.70*count); b=floor(.15*count);
train=order(1:a); validation=order(a+1:a+b); test=order(a+b+1:end);
split=repmat("Rejected",n,1); split(train)="Train"; split(validation)="Validation"; split(test)="Test";
featureNames={'Altitude_m','Mach','Throttle'};
data=array2table([X,Y],'VariableNames',[featureNames,targets]);
data.Valid=valid; data.Split=split; data.Warnings=notes;
writetable(data,fullfile(folder,'simulation_dataset.csv'));
save(fullfile(folder,'dataset.mat'),'data','e','bounds','train','validation','test','label');
bestScore=Inf; best=[]; selection=table();
for familyIndex=1:numel(families)
    family=families{familyIndex};
    for setting=1:2
        fprintf('  Fitting %s setting %d...\n',family,setting); drawnow;
        try
            rng(4200+e.ID+100*familyIndex+setting,'twister');
            model=ml_fit_candidate(X(train,:),Y(train,:),family,setting);
            prediction=ml_apply_candidate(model,X(validation,:));
            m=ml_metrics(Y(validation,:),prediction,targets); score=mean(m.RelativeRMSE);
            message="OK";
            if isfinite(score)&&score<bestScore, best=model; bestScore=score; end
        catch exception
            score=Inf; message=string(exception.message);
        end
        item=table(string(family),setting,score,message,'VariableNames',{'Family','Setting','ValidationScore','Diagnostic'});
        if isempty(selection), selection=item; else, selection=[selection;item]; end %#ok<AGROW>
        writetable(selection,fullfile(folder,'model_selection.csv'));
    end
end
assert(~isempty(best),'All candidate fits failed; inspect model_selection.csv.');
% Winner is frozen before evaluating the untouched test rows.
predicted=ml_apply_candidate(best,X(test,:)); metrics=ml_metrics(Y(test,:),predicted,targets);
metrics.Properties.VariableNames{'MeetsAccuracyCriteria'}='MeetsSimulatorCriteriaOnly';
metrics.Engine_ID=repmat(e.ID,height(metrics),1);
metrics.Engine=repmat(string(e.Name),height(metrics),1);
metrics.Family=repmat(string(best.Family),height(metrics),1);
metrics.Label=repmat(string(label),height(metrics),1);
% Warm both paths and measure the same individual queries, including simulator overhead.
q=X(test(1:min(30,numel(test))),:);
ml_apply_candidate(best,q(1,:)); simulate_engine(e,flight_condition(q(1,1),q(1,2),q(1,3),'geometric'));
t0=tic;
for j=1:size(q,1), ml_apply_candidate(best,q(j,:)); end
predictionSeconds=toc(t0)/size(q,1);
t0=tic;
for j=1:size(q,1), simulate_engine(e,flight_condition(q(j,1),q(j,2),q(j,3),'geometric')); end
physicsSeconds=toc(t0)/size(q,1); speedup=physicsSeconds/max(predictionSeconds,eps);
project=project_paths();
bundle=struct('ProjectRoot',project.root,'Mode','EXPERIMENTAL_SIMULATOR_ONLY','Operational',false,'Label',label, ...
    'Model',best,'EngineSnapshot',e,'Fingerprint',e.Fingerprint,'FeatureNames',{featureNames}, ...
    'TargetNames',{targets},'Bounds',bounds,'ValidationScore',bestScore,'TestMetrics',metrics, ...
    'RawPredictionSeconds',predictionSeconds,'PhysicsSeconds',physicsSeconds, ...
    'TrainingRows',numel(train),'ValidationRows',numel(validation),'TestRows',numel(test));
save(fullfile(folder,'experimental_model.mat'),'bundle','-v7.3');
writetable(metrics,fullfile(folder,'test_metrics.csv'));
testRows=data(test,1:6);
for j=1:3, testRows.(['Predicted_',targets{j}])=predicted(:,j); end
writetable(testRows,fullfile(folder,'test_predictions.csv'));
% Preserve the PW127-family airflow assumption as a distinct sensitivity study.
if e.ID==10
    trialEngine=e; trialEngine.Params.MassFlow_kgs=8.49;
    trialEngine.Fingerprint='EXPERIMENTAL-PW127-FAMILY-AIRFLOW'; trialEngine.Estimated=true;
    altitude=(0:1000: min(9000,e.Params.MaxAltitude_m))';
    originalPower=NaN(size(altitude)); candidatePower=originalPower;
    for k=1:numel(altitude)
        f=flight_condition(altitude(k),0,1,'geometric');
        aResult=simulate_engine(e,f); bResult=simulate_engine(trialEngine,f);
        if aResult.Valid, originalPower(k)=aResult.ShaftPower_kW; end
        if bResult.Valid, candidatePower(k)=bResult.ShaftPower_kW; end
    end
    assumption=repmat("PW127 family airflow 8.49 kg/s; PW127G applicability unconfirmed; NOT training inputs",numel(altitude),1);
    review=table(altitude,originalPower,candidatePower,assumption);
    writetable(review,fullfile(folder,'PW127G_airflow_sensitivity.csv'));
end
% A separate altitude slice is for visualization, never model selection.
h=linspace(bounds(1,1),bounds(1,2),51)'; mx=min(.3,bounds(2,2));
sliceX=[h,repmat(mx,51,1),ones(51,1)]; sliceY=NaN(51,3);
for j=1:51
    r=simulate_engine(e,flight_condition(h(j),mx,1,'geometric'));
    if r.Valid, sliceY(j,:)=[r.(targets{1}),r.(targets{2}),r.(targets{3})]; end
end
slicePred=ml_apply_candidate(best,sliceX);
slice=array2table([sliceX,sliceY,slicePred],'VariableNames',[featureNames,targets,strcat('ML_',targets)]);
writetable(slice,fullfile(folder,'altitude_comparison.csv'));
% Save the trained model before plotting so a graphics failure cannot lose it.
plotNote="";
try
    fig=figure('Visible','off','Position',[100 100 1200 400]); closeFig=onCleanup(@() close(fig)); %#ok<NASGU>
    tiledlayout(1,3);
    for j=1:3
        nexttile; plot(h/1000,sliceY(:,j),'-',h/1000,slicePred(:,j),'--','LineWidth',1.4);
        xlabel('Geometric altitude (km)'); ylabel(targets{j},'Interpreter','none'); grid on;
        legend('Simulator','Experimental ML','Location','best');
    end
    sgtitle(sprintf('%s | Mach %.2f | throttle 1 | unvalidated simulation',e.Name,mx));
    exportgraphics(fig,fullfile(folder,'altitude_comparison.png'),'Resolution',140);
catch exception
    plotNote="Plot failed: "+string(exception.message);
    write_text(fullfile(folder,'plot_warning.txt'),char(plotNote));
end
row=table(e.ID,string(e.Name),"TRAINED",string(best.Family),numel(train),numel(validation),numel(test),nnz(~valid), ...
    mean(metrics.RelativeRMSE),speedup,plotNote,'VariableNames', ...
    {'Engine_ID','Engine','Status','SelectedFamily','TrainRows','ValidationRows','TestRows','RejectedRows','MeanRelativeRMSE','RawPredictionSpeedup','Diagnostic'});
fprintf('  Saved %s: mean test relative RMSE %.4g, raw speedup %.2fx\n',e.Name,mean(metrics.RelativeRMSE),speedup);
end
function restore_state(oldPath,oldRng)
path(oldPath); rng(oldRng);
end
function write_text(file,content)
fid=fopen(file,'w'); assert(fid~=-1,'Cannot write %s',file);
cleanup=onCleanup(@() fclose(fid)); %#ok<NASGU>
fprintf(fid,'%s',content);
end
