function result=RUN_J79_CHEB_CHECK(sourceFile)
%RUN_J79_CHEB_CHECK Test a frozen model trained offline on the uploaded data.
% Select engine_1/boundary_model.mat from the latest four-engine retraining run.
if nargin<1
    [n,d]=uigetfile('boundary_model.mat','Select engine_1 / boundary_model.mat from the latest retraining run');
    if isequal(n,0), result=[]; return; end
    sourceFile=fullfile(d,n);
end
s=load(sourceFile,'bundle'); old=s.bundle;
assert(old.EngineSnapshot.ID==1,'Select the J79 engine_1 file.');
addon=fileparts(mfilename('fullpath')); s=load(fullfile(addon,'frozen_cheb_model.mat'),'model'); model=s.model;
assert(strcmp(file_hash(fullfile(fileparts(sourceFile),'training.csv')),model.TrainingSHA256), ...
    'Training CSV differs from the data used for this frozen fit.');
assert(strcmp(file_hash(fullfile(fileparts(sourceFile),'validation.csv')),model.ValidationSHA256), ...
    'Validation CSV differs from the data used for this frozen fit.');
assert(isequal(old.Bounds,model.Bounds),'Model bounds differ.');
oldPath=path; oldRng=rng; clean=onCleanup(@() restore_state(oldPath,oldRng)); %#ok<NASGU>
addpath(old.ProjectRoot,genpath(fullfile(old.ProjectRoot,'matlab')),'-begin'); addpath(addon,'-begin');
% Numerical interchange check against predictions computed during fitting.
check=J79_CHEB_VALUES(model,model.CheckX);
assert(all(abs(check(:)-model.CheckY(:))<=1e-8*max(1,abs(model.CheckY(:)))), ...
    'MATLAB/Python model evaluation mismatch.');
result=run_check(old,model);
end
function result=run_check(old,model)
p=project_paths(); assert(strcmpi(char(p.root),char(old.ProjectRoot)),'Another project is active.');
db=DB_Interface(p.database_file); clean=onCleanup(@() delete(db)); %#ok<NASGU>
e=db_get_engine(db,1); assert(strcmp(e.Fingerprint,old.Fingerprint),'Simulator source or parameters changed.');
rng(41092027,'twister'); Z=[]; cohort=strings(0,1);
for a=0:3
    for b=0:3
        for c=0:3
            Z=[Z;(repmat([a b c],10,1)+rand(10,3))/4]; cohort=[cohort;repmat("Interior",10,1)]; %#ok<AGROW>
        end
    end
end
for axis=1:3
    for side=[0 1]
        block=rand(50,3); block(:,axis)=side;
        Z=[Z;block]; cohort=[cohort;repmat("Face",50,1)]; %#ok<AGROW>
    end
end
for free=1:3
    fixed=setdiff(1:3,free);
    for a=[0 1]
        for b=[0 1]
            block=rand(10,3); block(:,fixed(1))=a; block(:,fixed(2))=b;
            Z=[Z;block]; cohort=[cohort;repmat("Edge",10,1)]; %#ok<AGROW>
        end
    end
end
[a,b,c]=ndgrid([0 1]); Z=[Z;[a(:),b(:),c(:)]]; cohort=[cohort;repmat("SeenCorner",8,1)];
X=model.Bounds(:,1)'+Z.*(model.Bounds(:,2)-model.Bounds(:,1))';
% Explicitly check fresh points against every uploaded development/old test input.
fresh=cohort~="SeenCorner";
assert(isempty(intersect(X(fresh,:),model.PreviouslySeenX,'rows')),'Fresh points overlap previous data.');
Y=NaN(size(X)); accepted=false(size(X,1),1); notes=strings(size(X,1),1);
for i=1:size(X,1)
    r=simulate_engine(e,flight_condition(X(i,1),X(i,2),X(i,3),'geometric'));
    Y(i,:)=[r.Thrust_N,r.FuelFlow_kgs,r.TSFC_kgNs];
    accepted(i)=r.Valid&&all(isfinite(Y(i,:))); notes(i)=strjoin(string(r.Warnings),' | ');
    if mod(i,200)==0, fprintf('Evaluated %d/%d points\n',i,size(X,1)); drawnow; end
end
P=J79_CHEB_VALUES(model,X); folder=tempname(p.reports); mkdir(folder);
t=array2table([X,Y,P],'VariableNames',{'Altitude_m','Mach','Throttle','Thrust_N','FuelFlow_kgs','TSFC_kgNs', ...
    'ML_Thrust_N','ML_FuelFlow_kgs','ML_TSFC_kgNs'}); t.Cohort=cohort; t.Valid=accepted; t.Warnings=notes;
writetable(t,fullfile(folder,'predictions.csv'));
names={'Thrust_N','FuelFlow_kgs','TSFC_kgNs'}; labels=["Interior","Face","Edge","SeenCorner"]; metrics=table();
for i=1:numel(labels)
    mask=accepted & cohort==labels(i);
    assert(nnz(mask)>1,'Too few simulator-accepted points in %s. Predictions saved.',labels(i));
    assert(all(all(isfinite(P(mask,:)) & P(mask,:)>0)),'Invalid model prediction. Predictions saved; no pass awarded.');
    m=ml_metrics(Y(mask,:),P(mask,:),names);
    m.Properties.VariableNames{'MeetsAccuracyCriteria'}='MeetsSimulatorCriteriaOnly';
    m.Cohort=repmat(labels(i),3,1); m.AcceptedRows=repmat(nnz(mask),3,1);
    m.RejectedRows=repmat(nnz(cohort==labels(i)&~accepted),3,1);
    m.MaxAPE_Percent=100*max(abs((P(mask,:)-Y(mask,:))./Y(mask,:)),[],1)';
    if isempty(metrics), metrics=m; else, metrics=[metrics;m]; end %#ok<AGROW>
end
status='REVIEW_REQUIRED';
if all(metrics.MeetsSimulatorCriteriaOnly), status='MEETS_TESTED_SIMULATOR_CRITERIA'; end
bundle=struct('Mode','EXPERIMENTAL_J79_CHEB','Operational',false,'Model',model,'ProjectRoot',p.root, ...
    'EngineSnapshot',e,'Fingerprint',e.Fingerprint,'TestMetrics',metrics,'Status',status, ...
    'Label','Unvalidated-simulator surrogate; corners are seen training checks');
save(fullfile(folder,'j79_cheb_model.mat'),'bundle','-v7.3');
writetable(metrics,fullfile(folder,'J79_FINAL_METRICS.csv'));
result=struct('Folder',folder,'ModelFile',fullfile(folder,'j79_cheb_model.mat'),'Metrics',metrics,'Status',status);
save(fullfile(folder,'check_result.mat'),'result'); disp(metrics);
fprintf('\n%s\nSaved: %s\nUpload J79_FINAL_METRICS.csv.\n',status,folder);
end
function h=file_hash(file)
fid=fopen(file,'rb'); assert(fid~=-1,'Missing source CSV: %s',file); clean=onCleanup(@() fclose(fid)); %#ok<NASGU>
bytes=fread(fid,Inf,'*uint8'); md=java.security.MessageDigest.getInstance('SHA-256'); md.update(bytes);
h=lower(reshape(dec2hex(typecast(md.digest(),'uint8'),2).',1,[]));
end
function restore_state(oldPath,oldRng)
path(oldPath); rng(oldRng);
end
