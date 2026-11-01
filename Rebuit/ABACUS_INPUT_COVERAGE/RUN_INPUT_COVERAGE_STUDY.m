function report=RUN_INPUT_COVERAGE_STUDY(runFile,j79File)
%RUN_INPUT_COVERAGE_STUDY Evaluate frozen models across joint input space.
% Uses 64 strata x 10 fresh interior points plus 98 boundary points per engine.
% No retraining or database changes. Original and reviewed artifacts are retained.
if nargin<1
    [name,folder]=uigetfile('EXPERIMENTAL_RUN.mat','Select EXPERIMENTAL_RUN.mat from the original 13-engine training run');
    if isequal(name,0), report=[]; fprintf('Cancelled.\n'); return; end
    runFile=fullfile(folder,name);
end
trainingFolder=fileparts(runFile);
if nargin<2
    [name,folder]=uigetfile('j79_reviewed_model.mat','Select the integrated j79_reviewed_model.mat');
    if isequal(name,0), report=[]; fprintf('Cancelled.\n'); return; end
    j79File=fullfile(folder,name);
end
run=load(runFile,'output'); summary=run.output.Summary;
ids=summary.Engine_ID(summary.Status=="TRAINED");
assert(~isempty(ids),'No trained models in the selected run.');
s=load(j79File,'bundle'); revised=s.bundle;
assert(revised.EngineSnapshot.ID==1 && isfield(revised,'TSFCMethod') && ...
    strcmp(revised.TSFCMethod,'PredictedFuelDividedByPredictedThrust'), 'Choose the integrated J79 bundle.');
oldPath=path; oldRng=rng; cleanup=onCleanup(@() restore_state(oldPath,oldRng)); %#ok<NASGU>
addpath(revised.ProjectRoot,genpath(fullfile(revised.ProjectRoot,'matlab')),'-begin');
p=project_paths(); assert(strcmpi(char(p.root),char(revised.ProjectRoot)),'Another project copy is active.');
report=study_models(p,ids,trainingFolder,j79File);
end
function report=study_models(p,ids,trainingFolder,j79File)
db=DB_Interface(p.database_file); closeDB=onCleanup(@() delete(db)); %#ok<NASGU>
folder=tempname(p.reports); mkdir(folder); rows=table(); aggregate=table();
fprintf('Coverage study output: %s\n',folder);
for k=1:numel(ids)
    id=ids(k); dest=fullfile(folder,sprintf('engine_%d',id)); mkdir(dest);
    fprintf('\nEngine %d/%d (ID %d)\n',k,numel(ids),id); drawnow;
    try
        oldFolder=fullfile(trainingFolder,sprintf('engine_%d',id));
        modelFile=fullfile(oldFolder,'experimental_model.mat');
        if id==1, modelFile=j79File; end
        s=load(modelFile,'bundle'); b=s.bundle; e=db_get_engine(db,id);
        assert(b.EngineSnapshot.ID==id && strcmp(b.Mode,'EXPERIMENTAL_SIMULATOR_ONLY') && ~b.Operational,'Unexpected model bundle.');
        assert(strcmp(e.Fingerprint,b.Fingerprint),'Model fingerprint is stale.');
        dataset=readtable(fullfile(oldFolder,'simulation_dataset.csv'),'TextType','string');
        [row,metrics]=study_one(e,b,dataset,dest,modelFile);
        if isempty(aggregate), aggregate=metrics; else, aggregate=[aggregate;metrics]; end %#ok<AGROW>
    catch ex
        row=table(id,"","ERROR",NaN,NaN,NaN,NaN,NaN,NaN,string(ex.message), ...
            'VariableNames',{'Engine_ID','Engine','Status','EmptyTrainingCells','MinTrainingPerCell', ...
            'FreshAccepted','FreshRejected','InvalidPredictions','FailedTargetChecks','Note'});
        write_text(fullfile(dest,'ERROR.txt'),getReport(ex,'extended','hyperlinks','off'));
        fprintf('ERROR: %s\n',ex.message);
    end
    if isempty(rows), rows=row; else, rows=[rows;row]; end %#ok<AGROW>
    writetable(rows,fullfile(folder,'COVERAGE_SUMMARY.csv'));
    if ~isempty(aggregate), writetable(aggregate,fullfile(folder,'COVERAGE_METRICS.csv')); end
end
report=struct('Folder',folder,'Summary',rows,'Metrics',aggregate, ...
    'Label','Experimental simulator coverage assessment; not manufacturer validation');
save(fullfile(folder,'coverage_study.mat'),'report'); disp(rows);
fprintf('\nSaved: %s\nSend COVERAGE_SUMMARY.csv and COVERAGE_METRICS.csv.\n',folder);
end
function [row,metrics]=study_one(e,b,dataset,folder,modelFile)
rng(18092026+e.ID,'twister'); bounds=b.Bounds;
assert(isequal(size(bounds),[3 2])&&all(isfinite(bounds(:)))&&all(bounds(:,2)>bounds(:,1)),'Invalid bounds.');
% Stratified joint sampling: every altitude/Mach/throttle cell receives 10 points.
Z=zeros(640,3); cellIDs=zeros(640,1); cursor=0; cellSpec=zeros(64,3);
for a=1:4
    for m=1:4
        for t=1:4
            id=(a-1)*16+(m-1)*4+t; range=cursor+(1:10);
            Z(range,:)=(repmat([a-1,m-1,t-1],10,1)+rand(10,3))/4;
            cellIDs(range)=id; cellSpec(id,:)=[a,m,t]; cursor=cursor+10;
        end
    end
end
% 5 x 5 x 5 lattice, retain shell only: faces, edges and eight corners.
[a,m,t]=ndgrid(linspace(0,1,5)); shell=[a(:),m(:),t(:)];
shell=shell(any(shell==0 | shell==1,2),:);
assert(size(shell,1)==98,'Boundary construction error.');
Z=[Z;shell]; cellIDs=[cellIDs;zeros(98,1)];
X=bounds(:,1)'+Z.*(bounds(:,2)-bounds(:,1))'; n=size(X,1);
cohort=[repmat("Interior",640,1);repmat("Boundary",98,1)];
Y=NaN(n,3); accepted=false(n,1); notes=strings(n,1);
for i=1:n
    r=simulate_engine(e,flight_condition(X(i,1),X(i,2),X(i,3),'geometric'));
    for j=1:3, Y(i,j)=r.(b.TargetNames{j}); end
    accepted(i)=r.Valid&&all(isfinite(Y(i,:))); notes(i)=strjoin(string(r.Warnings),' | ');
    if mod(i,120)==0, fprintf('  Simulated %d/%d\n',i,n); drawnow; end
end
pred=ml_apply_candidate(b.Model,X);
if e.ID==1
    assert(strcmp(b.TSFCMethod,'PredictedFuelDividedByPredictedThrust'),'Missing reviewed J79 rule.');
    pred(:,3)=NaN; ok=isfinite(pred(:,1))&pred(:,1)>0&isfinite(pred(:,2))&pred(:,2)>=0;
    pred(ok,3)=pred(ok,2)./pred(ok,1);
end
available=all(isfinite(pred)&pred>=0,2);
points=array2table([X,Y,pred],'VariableNames',[b.FeatureNames,b.TargetNames,strcat('ML_',b.TargetNames)]);
points.Cohort=cohort; points.CellID=cellIDs; points.SimulatorAccepted=accepted;
points.PredictionAvailable=available; points.Warnings=notes;
writetable(points,fullfile(folder,'coverage_points.csv'));
parts=cell(2,1);
for group=1:2
    labels=["Interior","Boundary"]; mask=accepted&cohort==labels(group);
    parts{group}=score_group(Y,pred,mask,b.TargetNames);
    parts{group}.Cohort=repmat(labels(group),3,1);
end
metrics=vertcat(parts{:}); metrics.Engine_ID=repmat(e.ID,height(metrics),1);
metrics.Engine=repmat(string(e.Name),height(metrics),1);
writetable(metrics,fullfile(folder,'metrics.csv'));
% Count ORIGINAL training rows only, excluding validation and test rows.
train=dataset(string(dataset.Split)=="Train",:);
u=(train{:,b.FeatureNames}-bounds(:,1)')./(bounds(:,2)-bounds(:,1))';
assert(all(isfinite(u(:)))&&all(u(:)>=-1e-12 & u(:)<=1+1e-12),'Original training data outside saved bounds.');
bins=min(4,max(1,floor(4*u)+1)); originalIDs=(bins(:,1)-1)*16+(bins(:,2)-1)*4+bins(:,3);
counts=accumarray(originalIDs,1,[64,1]);
worst=NaN(64,1); freshCount=zeros(64,1);
for id=1:64
    mask=accepted & available & cellIDs==id; freshCount(id)=nnz(mask);
    if any(mask)
        scale=max(mean(abs(Y(mask,:)),1),eps);
        worst(id)=100*max(sqrt(mean((pred(mask,:)-Y(mask,:)).^2,1))./scale);
    end
end
cells=table((1:64)',cellSpec(:,1),cellSpec(:,2),cellSpec(:,3),counts,freshCount,worst, ...
    'VariableNames',{'CellID','AltitudeBin','MachBin','ThrottleBin','OriginalTrainCount', ...
    'FreshScoredCount','WorstTargetNRMSE_Percent'});
writetable(cells,fullfile(folder,'joint_input_cells.csv'));
save(fullfile(folder,'coverage_snapshot.mat'),'b','bounds','modelFile','metrics');
status="MEETS_CURRENT_SIMULATOR_CRITERIA";
failed=nnz(~metrics.MeetsOriginalCriteria);
if failed>0, status="REVIEW_REQUIRED"; end
% Keep constant-target R2 flags visible instead of silently declaring a pass.
constantOnly=all(metrics.MeetsErrorLimits & (metrics.R2>=.95 | metrics.ConstantReference));
if failed>0 && constantOnly, status="CONSTANT_TARGET_R2_REVIEW"; end
note="Frozen-model test; no real-engine validation";
row=table(e.ID,string(e.Name),status,nnz(counts==0),min(counts),nnz(accepted),nnz(~accepted), ...
    nnz(accepted&~available),failed,note,'VariableNames', ...
    {'Engine_ID','Engine','Status','EmptyTrainingCells','MinTrainingPerCell','FreshAccepted','FreshRejected', ...
    'InvalidPredictions','FailedTargetChecks','Note'});
% Plot failures are nonfatal; numerical evidence is already saved.
try
    fig=figure('Visible','off','Position',[100 100 1100 450]); closeFig=onCleanup(@() close(fig)); %#ok<NASGU>
    tiledlayout(1,2); nexttile;
    scatter3(train.Altitude_m/1000,train.Mach,train.Throttle,12,train.Throttle,'filled');
    xlabel('Altitude (km)'); ylabel('Mach'); zlabel('Throttle'); title('Original training combinations'); grid on;
    nexttile; scatter3(X(:,1)/1000,X(:,2),X(:,3),12,double(cohort=="Boundary"),'filled');
    xlabel('Altitude (km)'); ylabel('Mach'); zlabel('Throttle'); title('640 interior + 98 boundary test points'); grid on;
    sgtitle([e.Name,' | experimental simulator coverage']);
    exportgraphics(fig,fullfile(folder,'input_coverage.png'),'Resolution',140);
catch ex
    write_text(fullfile(folder,'plot_warning.txt'),ex.message);
end
fprintf('  %s: %s; %d empty original training cells\n',e.Name,status,nnz(counts==0));
end
function metrics=score_group(Y,P,mask,names)
rows=cell(3,1);
for j=1:3
    y=Y(mask,j); pred=P(mask,j); n=numel(y); bad=nnz(~isfinite(pred)|pred<0);
    r2=NaN; rmse=NaN; mae=NaN; mape=NaN; nrmse=NaN; nmae=NaN; constant=false;
    if n>0 && bad==0
        err=pred-y; rmse=sqrt(mean(err.^2)); mae=mean(abs(err));
        total=sum((y-mean(y)).^2); constant=total<=eps(max(1,sum(y.^2)));
        if ~constant, r2=1-sum(err.^2)/total; end
        scale=max(mean(abs(y)),eps); nrmse=rmse/scale; nmae=mae/scale;
        nonzero=abs(y)>1e-12*max(1,max(abs(y)));
        if any(nonzero), mape=100*mean(abs(err(nonzero)./y(nonzero))); end
    end
    limits=n>0 && bad==0 && nrmse<.02 && nmae<.015 && mape<5;
    strict=limits && isfinite(r2) && r2>=.95;
    rows{j}=table(string(names{j}),n,bad,r2,rmse,mae,mape,nrmse,nmae,constant,limits,strict, ...
        'VariableNames',{'Target','AcceptedRows','InvalidPredictions','R2','RMSE','MAE','MAPE_Percent', ...
        'RelativeRMSE','RelativeMAE','ConstantReference','MeetsErrorLimits','MeetsOriginalCriteria'});
end
metrics=vertcat(rows{:});
end
function restore_state(oldPath,oldRng)
path(oldPath); rng(oldRng);
end
function write_text(file,text)
fid=fopen(file,'w'); assert(fid~=-1,'Cannot write report file.'); cleanup=onCleanup(@() fclose(fid)); %#ok<NASGU>
fprintf(fid,'%s',text);
end
