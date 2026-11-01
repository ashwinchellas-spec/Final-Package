function result=RUN_BOUNDARY_RETRAIN(runFile,coverageFile)
%RUN_BOUNDARY_RETRAIN Repair Kaveri reporting and retrain four boundary failures.
% Select the ORIGINAL EXPERIMENTAL_RUN.mat and completed coverage_study.mat.
% All output goes to a new reports folder. No database/source/model overwrites.
if nargin<1
    [n,d]=uigetfile('EXPERIMENTAL_RUN.mat','Select original EXPERIMENTAL_RUN.mat');
    if isequal(n,0), result=[]; return; end
    runFile=fullfile(d,n);
end
if nargin<2
    [n,d]=uigetfile('coverage_study.mat','Select completed coverage_study.mat');
    if isequal(n,0), result=[]; return; end
    coverageFile=fullfile(d,n);
end
trainingFolder=fileparts(runFile); coverageFolder=fileparts(coverageFile);
s=load(fullfile(trainingFolder,'engine_1','experimental_model.mat'),'bundle');
root=s.bundle.ProjectRoot; oldPath=path; oldRng=rng;
cleanup=onCleanup(@() restore_state(oldPath,oldRng)); %#ok<NASGU>
addpath(root,genpath(fullfile(root,'matlab')),'-begin');
addpath(fileparts(mfilename('fullpath')),'-begin');
p=project_paths(); assert(strcmpi(char(p.root),char(root)),'Another project is active.');
assert(license('test','Statistics_Toolbox'),'Statistics and Machine Learning Toolbox is needed.');
result=run_all(p,trainingFolder,coverageFolder);
end
function result=run_all(p,trainingFolder,coverageFolder)
db=DB_Interface(p.database_file); closeDB=onCleanup(@() delete(db)); %#ok<NASGU>
folder=tempname(p.reports); mkdir(folder);
fprintf('New output folder: %s\n',folder);
try
    recover_kaveri(db,trainingFolder,coverageFolder,folder);
catch ex
    write_text(fullfile(folder,'KAVERI_RECOVERY_ERROR.txt'),getReport(ex,'extended','hyperlinks','off'));
    fprintf('Kaveri recovery requires review: %s\n',ex.message);
end
summary=table(); combined=table(); ids=[1 2 3 6];
for index=1:numel(ids)
    id=ids(index); dest=fullfile(folder,sprintf('engine_%d',id)); mkdir(dest);
    try
        e=db_get_engine(db,id); s=load(fullfile(trainingFolder,sprintf('engine_%d',id),'experimental_model.mat'),'bundle');
        b=s.bundle; assert(strcmp(b.Fingerprint,e.Fingerprint),'Engine %d baseline is stale.',id);
        fprintf('\nEngine %d/%d: %s\n',index,numel(ids),e.Name); drawnow;
        [row,metrics]=train_one(e,b,dest);
        if isempty(combined), combined=metrics; else, combined=[combined;metrics]; end %#ok<AGROW>
    catch ex
        write_text(fullfile(dest,'ERROR.txt'),getReport(ex,'extended','hyperlinks','off'));
        row=table(id,"","ERROR","",NaN,NaN,string(ex.message), ...
            'VariableNames',{'Engine_ID','Engine','Status','Model','WorstFreshRelativeRMSE','FailedFreshChecks','Note'});
        fprintf('ERROR: %s\n',ex.message);
    end
    if isempty(summary), summary=row; else, summary=[summary;row]; end %#ok<AGROW>
    writetable(summary,fullfile(folder,'RETRAIN_SUMMARY.csv'));
    if ~isempty(combined), writetable(combined,fullfile(folder,'FRESH_TEST_METRICS.csv')); end
end
result=struct('Folder',folder,'Summary',summary,'Metrics',combined,'Operational',false);
save(fullfile(folder,'boundary_retrain_run.mat'),'result'); disp(summary);
fprintf('\nSend RETRAIN_SUMMARY.csv, FRESH_TEST_METRICS.csv and KAVERI_RECOVERY.csv from:\n%s\n',folder);
end
function recover_kaveri(db,trainingFolder,coverageFolder,folder)
% Native MATLAB table avoids CSV header inference. Original CSV is not changed.
s=load(fullfile(trainingFolder,'engine_8','dataset.mat'));
assert(isfield(s,'data')&&istable(s.data)&&isfield(s,'train'),'Native dataset table or split indices missing.');
assert(s.e.ID==8,'Wrong engine dataset.');
e=db_get_engine(db,8); assert(strcmp(e.Fingerprint,s.e.Fingerprint),'Kaveri dataset is stale.');
t=s.data; tr=s.train(:); va=s.validation(:); te=s.test(:);
assert(numel(unique([tr;va;te]))==numel([tr;va;te]),'Overlapping saved splits.');
assert(all([tr;va;te]>=1 & [tr;va;te]<=height(t)),'Invalid saved split indices.');
assert(all(string(t.Split(tr))=="Train"),'Saved training indices disagree with native Split.');
X=t{tr,{'Altitude_m','Mach','Throttle'}};
Z=(X-s.bounds(:,1)')./(s.bounds(:,2)-s.bounds(:,1))';
assert(all(isfinite(Z(:)))&&all(Z(:)>=-1e-12 & Z(:)<=1+1e-12),'Training values outside bounds.');
bins=min(4,max(1,floor(4*Z)+1)); cellID=(bins(:,1)-1)*16+(bins(:,2)-1)*4+bins(:,3);
counts=accumarray(cellID,1,[64,1]);
m=readtable(fullfile(coverageFolder,'engine_8','metrics.csv'),'Delimiter',',', ...
    'NumHeaderLines',0,'VariableNamingRule','preserve','TextType','string');
assert(height(m)==6&&all(m.Engine_ID==8),'Unexpected Kaveri metric table.');
status="REVIEW_REQUIRED";
if all(m.MeetsOriginalCriteria), status="MEETS_CURRENT_SIMULATOR_CRITERIA"; end
recovered=table(8,string(e.Name),status,nnz(counts==0),min(counts),numel(tr), ...
    'VariableNames',{'Engine_ID','Engine','Status','EmptyTrainingCells','MinTrainingPerCell','TrainRows'});
writetable(recovered,fullfile(folder,'KAVERI_RECOVERY.csv'));
writetable(m,fullfile(folder,'KAVERI_RETAINED_METRICS.csv'));
writetable(table((1:64)',counts,'VariableNames',{'CellID','TrainRows'}),fullfile(folder,'KAVERI_TRAINING_CELLS.csv'));
fprintf('Kaveri report recovered from native MAT data: %s\n',status);
end
function [row,fresh]=train_one(e,b,folder)
% Train: 2048 interior, 600 faces, 240 edges, 8 corners = 2896 conditions.
[X,C]=design(b.Bounds,32,100,20,true,28092026+e.ID);
[Y,V]=simulate_set(e,X,C,fullfile(folder,'training.csv'));
assert(nnz(V)>1000,'Too few usable training points.');
% Validation: new 640 interior, 300 faces, 120 edges; corners are NOT a test.
[Xv,Cv]=design(b.Bounds,10,50,10,false,29092026+e.ID);
assert(isempty(intersect(Xv,X,'rows')),'Train/validation overlap.');
[Yv,Vv]=simulate_set(e,Xv,Cv,fullfile(folder,'validation.csv'));
save(fullfile(folder,'development_data.mat'),'X','C','Y','V','Xv','Cv','Yv','Vv','e','b','-v7.3');
families={'PolyRaw','PolyLog','GPRLog'}; bestScore=Inf; best=[]; selection=table();
for k=1:numel(families)
    family=families{k}; fprintf('  Training %s (GPR may take several minutes)...\n',family); drawnow;
    try
        rng(30092026+e.ID+k,'twister'); model=fit_model(X(V,:),Y(V,1:2),family);
        pred=BOUNDARY_MODEL_VALUES(model,Xv); m=group_metrics(Yv,pred,Vv,Cv);
        score=max(m.RelativeRMSE); if any(~isfinite(m.RelativeRMSE)), score=Inf; end
        if isfinite(score)&&score<bestScore, bestScore=score; best=model; end
        note="OK"; writetable(m,fullfile(folder,[family,'_validation_metrics.csv']));
    catch ex
        score=Inf; note=string(ex.message);
    end
    item=table(string(family),score,note,'VariableNames',{'Model','WorstValidationRelativeRMSE','Diagnostic'});
    if isempty(selection), selection=item; else, selection=[selection;item]; end %#ok<AGROW>
    writetable(selection,fullfile(folder,'model_selection.csv'));
end
assert(~isempty(best),'No candidate fit succeeded. See model_selection.csv.');
% Freeze winner BEFORE generating the untouched final random conditions.
frozen=struct('Mode','EXPERIMENTAL_BOUNDARY_REVISION','Operational',false,'Model',best, ...
    'EngineSnapshot',e,'Fingerprint',e.Fingerprint,'Bounds',b.Bounds,'ProjectRoot',b.ProjectRoot, ...
    'ValidationScore',bestScore,'Label','Surrogate of unvalidated simulation; not manufacturer performance');
save(fullfile(folder,'frozen_before_test.mat'),'frozen','-v7.3');
[Xt,Ct]=design(b.Bounds,10,50,10,false,31092026+e.ID);
assert(isempty(intersect(Xt,X,'rows'))&&isempty(intersect(Xt,Xv,'rows')),'Test/development overlap.');
[Yt,Vt]=simulate_set(e,Xt,Ct,fullfile(folder,'fresh_test.csv'));
pred=BOUNDARY_MODEL_VALUES(best,Xt); fresh=group_metrics(Yt,pred,Vt,Ct);
fresh.Engine_ID=repmat(e.ID,height(fresh),1); fresh.Engine=repmat(string(e.Name),height(fresh),1);
fresh.Model=repmat(string(best.Family),height(fresh),1);
writetable(fresh,fullfile(folder,'fresh_test_metrics.csv'));
% Old corner weaknesses become TRAINING regression checks, never held-out evidence.
cornerMask=C=="Corner" & V; cornerPred=BOUNDARY_MODEL_VALUES(best,X(cornerMask,:));
corner=group_metrics(Y(cornerMask,:),cornerPred,true(nnz(cornerMask),1),repmat("SeenCorner",nnz(cornerMask),1));
writetable(corner,fullfile(folder,'seen_corner_regression.csv'));
points=array2table([Xt,Yt,pred],'VariableNames',{'Altitude_m','Mach','Throttle','Thrust_N', ...
    'FuelFlow_kgs','TSFC_kgNs','ML_Thrust_N','ML_FuelFlow_kgs','ML_TSFC_kgNs'});
points.Cohort=Ct; points.SimulatorAccepted=Vt;
writetable(points,fullfile(folder,'fresh_test_predictions.csv'));
status="REVIEW_REQUIRED";
if all(fresh.MeetsCriteria)&&~isempty(corner)&&all(corner.MeetsCriteria), status="MEETS_TESTED_SIMULATOR_CRITERIA"; end
bundle=frozen; bundle.FreshTestMetrics=fresh; bundle.SeenCornerMetrics=corner; bundle.Status=char(status);
save(fullfile(folder,'boundary_model.mat'),'bundle','-v7.3');
row=table(e.ID,string(e.Name),status,string(best.Family),max(fresh.RelativeRMSE),nnz(~fresh.MeetsCriteria), ...
    "Fresh interior/face/edge test; corners are seen training checks",'VariableNames', ...
    {'Engine_ID','Engine','Status','Model','WorstFreshRelativeRMSE','FailedFreshChecks','Note'});
fprintf('  %s: %s\n',e.Name,status);
end
function model=fit_model(X,Y,family)
assert(all(Y(:)>0),'Positive thrust and fuel are needed for the log candidates.');
useLog=~strcmp(family,'PolyRaw'); targets=Y;
if useLog, targets=log(Y); end
if startsWith(family,'Poly')
    core=ml_fit_candidate(X,targets,'Poly',2);
else
    % Sparse GP: trained on all rows, 1000 active basis points, Matern 5/2 kernel.
    mu=mean(X,1); sd=std(X,0,1); sd(sd==0)=1; Z=(X-mu)./sd;
    ym=mean(targets,1); ys=std(targets,0,1); ys(ys==0)=1;
    core=struct('Family','GPR','Mu',mu,'Sigma',sd,'YMu',ym,'YSigma',ys,'Objects',{cell(1,2)});
    for j=1:2
        fprintf('    GPR target %d/2\n',j); drawnow;
        core.Objects{j}=fitrgp(Z,(targets(:,j)-ym(j))/ys(j),'KernelFunction','ardmatern52', ...
            'Standardize',false,'FitMethod','sr','PredictMethod','fic', ...
            'ActiveSetSize',min(1000,size(Z,1)),'ActiveSetMethod','random');
    end
end
model=struct('Core',core,'LogTargets',useLog,'Family',family);
end
function [X,C]=design(bounds,perCell,perFace,perEdge,corners,seed)
rng(seed,'twister'); Z=[]; C=strings(0,1);
for a=0:3
    for b=0:3
        for c=0:3
            Z=[Z;(repmat([a b c],perCell,1)+rand(perCell,3))/4]; %#ok<AGROW>
            C=[C;repmat("Interior",perCell,1)]; %#ok<AGROW>
        end
    end
end
for axis=1:3
    for side=[0 1]
        block=rand(perFace,3); block(:,axis)=side;
        Z=[Z;block]; C=[C;repmat("Face",perFace,1)]; %#ok<AGROW>
    end
end
for free=1:3
    fixed=setdiff(1:3,free);
    for a=[0 1]
        for b=[0 1]
            block=rand(perEdge,3); block(:,fixed(1))=a; block(:,fixed(2))=b;
            Z=[Z;block]; C=[C;repmat("Edge",perEdge,1)]; %#ok<AGROW>
        end
    end
end
if corners
    [a,b,c]=ndgrid([0 1]); Z=[Z;[a(:),b(:),c(:)]]; C=[C;repmat("Corner",8,1)];
end
assert(size(unique(Z,'rows'),1)==size(Z,1),'Duplicate sampling points.');
X=bounds(:,1)'+Z.*(bounds(:,2)-bounds(:,1))';
end
function [Y,V]=simulate_set(e,X,C,file)
n=size(X,1); Y=NaN(n,3); V=false(n,1); note=strings(n,1);
for i=1:n
    r=simulate_engine(e,flight_condition(X(i,1),X(i,2),X(i,3),'geometric'));
    Y(i,:)=[r.Thrust_N,r.FuelFlow_kgs,r.TSFC_kgNs];
    V(i)=r.Valid&&all(isfinite(Y(i,:)))&&all(Y(i,1:2)>0);
    note(i)=strjoin(string(r.Warnings),' | ');
    if mod(i,250)==0, fprintf('  Simulated %d/%d\n',i,n); drawnow; end
end
t=array2table([X,Y],'VariableNames',{'Altitude_m','Mach','Throttle','Thrust_N','FuelFlow_kgs','TSFC_kgNs'});
t.Cohort=C; t.Valid=V; t.Warnings=note; writetable(t,file);
end
function metrics=group_metrics(Y,P,V,C)
labels=unique(C,'stable'); rows=cell(0,1); names={'Thrust_N','FuelFlow_kgs','TSFC_kgNs'};
for i=1:numel(labels)
    mask=V & C==labels(i); n=nnz(mask); total=nnz(C==labels(i));
    for j=1:3
        y=Y(mask,j); pred=P(mask,j); bad=nnz(~isfinite(pred)|pred<=0);
        r2=NaN; nr=NaN; na=NaN; mape=NaN; maxape=NaN;
        if n>1&&bad==0
            d=pred-y; ss=sum((y-mean(y)).^2);
            if ss>eps(max(1,sum(y.^2))), r2=1-sum(d.^2)/ss; end
            nr=sqrt(mean(d.^2))/max(mean(abs(y)),eps); na=mean(abs(d))/max(mean(abs(y)),eps);
            nonzero=abs(y)>1e-12*max(1,max(abs(y)));
            if any(nonzero), ape=100*abs(d(nonzero)./y(nonzero)); mape=mean(ape); maxape=max(ape); end
        end
        pass=isfinite(r2)&&r2>=.95&&nr<.02&&na<.015&&mape<5&&bad==0;
        rows{end+1,1}=table(labels(i),string(names{j}),total,n,total-n,bad,r2,nr,na,mape,maxape,pass, ...
            'VariableNames',{'Cohort','Target','CandidateRows','AcceptedRows','RejectedRows','InvalidPredictions', ...
            'R2','RelativeRMSE','RelativeMAE','MAPE_Percent','MaxAPE_Percent','MeetsCriteria'}); %#ok<AGROW>
    end
end
metrics=vertcat(rows{:});
end
function restore_state(oldPath,oldRng)
path(oldPath); rng(oldRng);
end
function write_text(file,content)
fid=fopen(file,'w'); assert(fid~=-1,'Cannot write diagnostic.'); c=onCleanup(@() fclose(fid)); %#ok<NASGU>
fprintf(fid,'%s',content);
end
