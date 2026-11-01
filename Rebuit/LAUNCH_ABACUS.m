function [app, registry, smoke] = LAUNCH_ABACUS(action)
%LAUNCH_ABACUS Open the packaged project using relocated experimental models.
% Run from a fresh MATLAB session. No training, seeding or parameter fitting.
% LAUNCH_ABACUS('check') checks fingerprints and runs 13 small prediction queries.
if nargin < 1, action = 'gui'; end
action = validatestring(action, {'gui','check'});
app = []; smoke = table();
packageRoot = fileparts(mfilename('fullpath'));
root = fullfile(packageRoot,'Aircraft_Engine_Digital_Twin');
assert(isfile(fullfile(root,'database','engine_analysis.db')), ...
    'The working engine_analysis.db is missing. Extract the complete package.');
cd(root);
addpath(packageRoot,root,genpath(fullfile(root,'matlab')),fullfile(root,'gui'), ...
    fullfile(root,'simulink'),fullfile(root,'scripts'), ...
    fullfile(packageRoot,'ABACUS_UNIFIED_PREDICTOR'), ...
    fullfile(packageRoot,'ABACUS_GUI_EXPERIMENT'),'-begin');
assert(strcmpi(which('project_paths'),fullfile(root,'project_paths.m')), ...
    'Another project copy is active. Restart MATLAB and open this launcher.');
assert(~isempty(which('sqlite')) && usejava('jvm'), ...
    'Database Toolbox and MATLAB JVM support are required.');
fprintf('Checking packaged database and 13 saved model fingerprints...\n');
bundles = readAndCheckModels(root);
cacheFolder = tempname(fullfile(root,'reports'));
mkdir(cacheFolder);
entries = repmat(struct('Engine_ID',0,'Engine',"",'Mode',"", ...
    'ModelFile',"",'ProjectRoot',string(root)),1,13);
for id=1:13
    bundle = bundles{id};
    bundle.PackagedOriginalProjectRoot = bundle.ProjectRoot;
    bundle.ProjectRoot = root;
    target = fullfile(cacheFolder,sprintf('engine_%d.mat',id));
    save(target,'bundle','-v7.3');
    entries(id).Engine_ID = id;
    entries(id).Engine = string(bundle.EngineSnapshot.Name);
    entries(id).Mode = string(bundle.Mode);
    entries(id).ModelFile = string(target);
end
registry = struct('Version','ABACUS-portable-registry-1', ...
    'ProjectRoot',string(root),'Entries',entries,'Operational',false, ...
    'CreatedUTC',string(datetime('now','TimeZone','UTC')), ...
    'Label',"Experimental simulator surrogates; independent engine validation pending.", ...
    'RegistryFile',string(fullfile(cacheFolder,'unified_registry.mat')));
save(char(registry.RegistryFile),'registry','-v7.3');
fprintf('Relocated registry: %s\n',registry.RegistryFile);
if strcmp(action,'check')
    rows=cell(13,1);
    for id=1:13
        result=PREDICT_UNIFIED_ENGINE(registry,id,[3000 .3 .8]);
        rows{id}=table(id,string(result.Engine(1)),logical(result.PredictionAvailable(1)), ...
            string(result.Note(1)),'VariableNames',{'Engine_ID','Engine','Available','Note'});
        fprintf('Prediction check %d/13: %d\n',id,result.PredictionAvailable(1));
    end
    smoke=vertcat(rows{:});
    writetable(smoke,fullfile(cacheFolder,'PORTABLE_SMOKE_CHECK.csv'));
    assert(all(smoke.Available),'Some predictions are unavailable; inspect PORTABLE_SMOKE_CHECK.csv.');
    disp(smoke);
    fprintf('Portable smoke check passed. This checks integration, not real-engine accuracy.\n');
else
    app=EngineAnalyser_v1(fullfile(root,'database','engine_analysis.db'));
    try
        predictor=fullfile(packageRoot,'ABACUS_UNIFIED_PREDICTOR','PREDICT_UNIFIED_ENGINE.m');
        tab=ATTACH_EXPERIMENTAL_ML(app,registry,predictor);
        app.Controls.TabGroup.SelectedTab=tab;
    catch ex
        delete(app);
        rethrow(ex);
    end
    if nargout==0, assignin('base','abacusApp',app); end
    fprintf('Use the engine dropdown inside Experimental ML. No file selection is needed.\n');
end
end

function bundles=readAndCheckModels(root)
reports=fullfile(root,'reports');
db=DB_Interface(fullfile(root,'database','engine_analysis.db'));
cleanup=onCleanup(@() delete(db)); %#ok<NASGU>
bundles=cell(13,1);
for id=1:13
    if id==1
        source=fullfile(reports,'tpeb3b145d_2787_4652_be91_516b9715a11b','j79_cheb_model.mat');
    elseif ismember(id,[2 3 6])
        source=fullfile(reports,'tp576b3ee3_f5b7_4064_a640_3e1db26ce4c3', ...
            sprintf('engine_%d',id),'boundary_model.mat');
    else
        source=fullfile(reports,'tp7e47faac_5d6d_4dd6_998e_762661399df7', ...
            sprintf('engine_%d',id),'experimental_model.mat');
    end
    assert(isfile(source),'Missing packaged model: %s',source);
    loaded=load(source,'bundle'); b=loaded.bundle;
    assert(b.EngineSnapshot.ID==id && ~b.Operational,'Unexpected model identity or status.');
    e=db_get_engine(db,id);
    assert(strcmp(e.Fingerprint,b.Fingerprint), ...
        'Engine %d has a stale model. Stop and review source/parameter changes; do not bypass this check.',id);
    b.PackagedSourceFile=source;
    bundles{id}=b;
    fprintf('Fingerprint %d/13 matched.\n',id);
end
end
