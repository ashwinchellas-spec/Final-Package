function registry = BUILD_UNIFIED_REGISTRY
%BUILD_UNIFIED_REGISTRY Collect the reviewed model files into one registry.
% No model is retrained and no project database is modified.
[name, folder] = uigetfile('EXPERIMENTAL_RUN.mat', ...
    'Select the original 13-engine EXPERIMENTAL_RUN.mat');
if isequal(name, 0)
    registry = [];
    return
end
originalRun = fullfile(folder, name);

[name, folder] = uigetfile('boundary_retrain_run.mat', ...
    'Select boundary_retrain_run.mat from the targeted retraining run');
if isequal(name, 0)
    registry = [];
    return
end
boundaryRun = fullfile(folder, name);

[name, folder] = uigetfile('j79_cheb_model.mat', ...
    'Select the tested J79 j79_cheb_model.mat');
if isequal(name, 0)
    registry = [];
    return
end
j79File = fullfile(folder, name);

originalFolder = fileparts(originalRun);
boundaryFolder = fileparts(boundaryRun);
j79Folder = fileparts(j79File);
seed = load(fullfile(originalFolder, 'engine_1', 'experimental_model.mat'), 'bundle');
assert(isfield(seed.bundle, 'ProjectRoot'), 'The original model has no project root.');
projectRoot = char(seed.bundle.ProjectRoot);
assert(isfolder(projectRoot), 'Project root is not available: %s', projectRoot);

revisedIDs = [2, 3, 6];
entries = repmat(struct('Engine_ID', 0, 'Engine', "", 'Mode', "", ...
    'ModelFile', "", 'ProjectRoot', string(projectRoot)), 1, 13);
for id = 1:13
    if id == 1
        modelFile = j79File;
    elseif ismember(id, revisedIDs)
        modelFile = fullfile(boundaryFolder, sprintf('engine_%d', id), ...
            'boundary_model.mat');
    else
        modelFile = fullfile(originalFolder, sprintf('engine_%d', id), ...
            'experimental_model.mat');
    end
    assert(isfile(modelFile), 'Missing model file for engine %d: %s', id, modelFile);
    loaded = load(modelFile, 'bundle');
    b = loaded.bundle;
    assert(b.EngineSnapshot.ID == id, 'Model file does not belong to engine %d.', id);
    entries(id).Engine_ID = id;
    entries(id).Engine = string(b.EngineSnapshot.Name);
    entries(id).Mode = string(b.Mode);
    entries(id).ModelFile = string(modelFile);
end

registry = struct('Version', 'ABACUS-unified-registry-1', ...
    'ProjectRoot', string(projectRoot), 'OriginalRunFile', string(originalRun), ...
    'BoundaryRunFile', string(boundaryRun), 'J79ModelFile', string(j79File), ...
    'CreatedUTC', string(datetime('now', 'TimeZone', 'UTC')), ...
    'Entries', entries, ...
    'Operational', false, ...
    'Label', "Experimental simulator surrogates; not manufacturer validation.");
outputFolder = fullfile(projectRoot, 'reports', ...
    ['unified_model_registry_', datestr(now, 'yyyymmdd_HHMMSS')]);
if ~isfolder(outputFolder)
    mkdir(outputFolder);
end
registry.RegistryFile = string(fullfile(outputFolder, 'unified_registry.mat'));
save(char(registry.RegistryFile), 'registry', '-v7.3');

displayTable = table([entries.Engine_ID]', {entries.Engine}', ...
    {entries.Mode}', {entries.ModelFile}', ...
    'VariableNames', {'Engine_ID', 'Engine', 'Mode', 'ModelFile'});
disp(displayTable);
fprintf('Unified registry saved to:\n%s\n', registry.RegistryFile);
fprintf('Use PREDICT_UNIFIED_ENGINE(registry, engineID, [altitude mach throttle]).\n');
end
