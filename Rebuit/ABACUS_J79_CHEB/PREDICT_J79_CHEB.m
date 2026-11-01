function predictions=PREDICT_J79_CHEB(modelFile,X)
%PREDICT_J79_CHEB Guarded queries for the separately saved revised model.
validateattributes(X,{'numeric'},{'2d','real','finite','ncols',3,'nonempty'});
s=load(modelFile,'bundle'); b=s.bundle;
assert(strcmp(b.Mode,'EXPERIMENTAL_J79_CHEB')&&~b.Operational,'Unexpected bundle.');
assert(strcmp(b.Status,'MEETS_TESTED_SIMULATOR_CRITERIA'), ...
    'This revision still needs review; inspect its fresh_test_metrics.csv.');
old=path; cleanup=onCleanup(@() path(old)); %#ok<NASGU>
addpath(b.ProjectRoot,genpath(fullfile(b.ProjectRoot,'matlab')),'-begin');
addpath(fileparts(mfilename('fullpath')),'-begin');
predictions=query_model(b,X);
end
function predictions=query_model(b,X)
p=project_paths(); assert(strcmpi(char(p.root),char(b.ProjectRoot)),'Another project is active.');
db=DB_Interface(p.database_file); clean=onCleanup(@() delete(db)); %#ok<NASGU>
e=db_get_engine(db,b.EngineSnapshot.ID);
assert(strcmp(e.Fingerprint,b.Fingerprint),'Source or parameters changed; this model is stale.');
inBox=all(X>=b.Model.Bounds(:,1)' & X<=b.Model.Bounds(:,2)',2);
Y=NaN(size(X,1),3); valid=false(size(X,1),1); note=repmat("Outside training bounds",size(X,1),1);
for i=find(inBox)'
    r=simulate_engine(e,flight_condition(X(i,1),X(i,2),X(i,3),'geometric'));
    if ~r.Valid, note(i)=strjoin(string(r.Warnings),' | '); continue; end
    value=J79_CHEB_VALUES(b.Model,X(i,:));
    if any(~isfinite(value))||any(value<=0), note(i)="Invalid surrogate output"; continue; end
    Y(i,:)=value; valid(i)=true; note(i)="Experimental simulator approximation; local error not guaranteed";
end
predictions=array2table([X,Y],'VariableNames',{'Altitude_m','Mach','Throttle','Thrust_N','FuelFlow_kgs','TSFC_kgNs'});
predictions.PredictionAvailable=valid; predictions.Note=note;
end
