function predictions = PREDICT_EXPERIMENTAL_ML(modelFile,X)
%PREDICT_EXPERIMENTAL_ML Query a saved experimental model in SI units.
% X columns: geometric altitude m, Mach, throttle. Bounds are a sampling box,
% not proof of valid engine operation. This function includes physics checks;
% the runner's raw model speedup excludes these checks and loading overhead.
validateattributes(X,{'numeric'},{'2d','real','finite','ncols',3,'nonempty'});
s=load(modelFile,'bundle'); b=s.bundle;
assert(strcmp(b.Mode,'EXPERIMENTAL_SIMULATOR_ONLY')&&~b.Operational,'Not an experimental bundle.');
oldPath=path; cleanup=onCleanup(@() path(oldPath)); %#ok<NASGU>
addpath(b.ProjectRoot,genpath(fullfile(b.ProjectRoot,'matlab')),'-begin');
% DB cleanup runs entirely inside this call, before outer path restoration.
predictions=predict_with_project(b,X);
end

function predictions=predict_with_project(b,X)
p=project_paths(); assert(strcmpi(char(p.root),char(b.ProjectRoot)),'Another project copy is active.');
db=DB_Interface(p.database_file); closeDB=onCleanup(@() delete(db)); %#ok<NASGU>
e=db_get_engine(db,b.EngineSnapshot.ID);
assert(strcmp(e.Fingerprint,b.Fingerprint),'Simulation inputs or source changed. Train a new experimental model.');
inBox=all(X>=b.Bounds(:,1)' & X<=b.Bounds(:,2)',2);
Y=NaN(size(X,1),numel(b.TargetNames)); accepted=false(size(X,1),1);
reason=repmat("Outside training bounds",size(X,1),1);
for i=find(inBox)'
    r=simulate_engine(e,flight_condition(X(i,1),X(i,2),X(i,3),'geometric'));
    if ~r.Valid
        reason(i)="Simulator rejects this point: "+strjoin(string(r.Warnings),' | '); continue;
    end
    value=ml_apply_candidate(b.Model,X(i,:));
    if any(~isfinite(value))||any(value<0)
        reason(i)="Nonfinite or negative ML output"; continue;
    end
    Y(i,:)=value; accepted(i)=true;
    reason(i)="Experimental prediction only; local accuracy is not guaranteed";
end
predictions=array2table([X,Y],'VariableNames',[b.FeatureNames,b.TargetNames]);
predictions.PredictionAvailable=accepted; predictions.Note=reason;
end
