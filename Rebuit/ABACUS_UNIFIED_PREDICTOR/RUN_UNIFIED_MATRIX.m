function result = RUN_UNIFIED_MATRIX(registry, levels)
%RUN_UNIFIED_MATRIX Evaluate all registered engines on a common normalized grid.
% This creates separate per-engine CSV files because jet and propeller targets
% have different physical units. It does not retrain or modify the database.
if nargin < 1 || isempty(registry)
    [name, folder] = uigetfile('unified_registry.mat', ...
        'Select unified_registry.mat');
    if isequal(name, 0)
        result = [];
        return
    end
    loaded = load(fullfile(folder, name), 'registry');
    registry = loaded.registry;
end
if nargin < 2 || isempty(levels)
    levels = [5, 4, 3];
end
assert(isstruct(registry) && isfield(registry, 'Entries'), ...
    'Build or load a registry first.');
validateattributes(levels, {'numeric'}, {'vector', 'integer', 'finite'});
assert(numel(levels) == 3 && all(levels >= 2), ...
    'levels must be [number_of_altitudes number_of_machs number_of_throttles].');

root = char(registry.ProjectRoot);
assert(isfolder(root), 'Project root is not available: %s', root);
oldPath = path;
oldRng = rng;
cleanup = onCleanup(@() restoreState(oldPath, oldRng)); %#ok<NASGU>
addpath(fileparts(mfilename('fullpath')), '-begin');

outputFolder = fullfile(root, 'reports', ...
    ['unified_matrix_', datestr(now, 'yyyymmdd_HHMMSS')]);
mkdir(outputFolder);
summary = table();
for id = 1:13
    entry = registry.Entries([registry.Entries.Engine_ID] == id);
    assert(numel(entry) == 1, 'Engine ID %d is not in the registry.', id);
    loaded = load(char(entry.ModelFile), 'bundle');
    b = loaded.bundle;
    bounds = bundleBounds(b);
    a = linspace(bounds(1, 1), bounds(1, 2), levels(1));
    m = linspace(bounds(2, 1), bounds(2, 2), levels(2));
    t = linspace(bounds(3, 1), bounds(3, 2), levels(3));
    [A, M, T] = ndgrid(a, m, t);
    X = [A(:), M(:), T(:)];
    predictions = PREDICT_UNIFIED_ENGINE(registry, id, X);
    writetable(predictions, fullfile(outputFolder, ...
        sprintf('engine_%d_predictions.csv', id)));
    row = table(id, string(b.EngineSnapshot.Name), string(b.Mode), size(X, 1), ...
        nnz(predictions.PredictionAvailable), ...
        nnz(~predictions.PredictionAvailable), ...
        'VariableNames', {'Engine_ID', 'Engine', 'ModelMode', 'RequestedRows', ...
        'AvailableRows', 'UnavailableRows'});
    if isempty(summary)
        summary = row;
    else
        summary = [summary; row]; %#ok<AGROW>
    end
end
writetable(summary, fullfile(outputFolder, 'UNIFIED_SUMMARY.csv'));
result = struct('Folder', outputFolder, 'Summary', summary, ...
    'Levels', levels, 'Operational', false, ...
    'Label', "Experimental simulator surrogates; not manufacturer validation.");
save(fullfile(outputFolder, 'unified_matrix_result.mat'), 'result');
disp(summary);
fprintf('Unified matrix saved to:\n%s\n', outputFolder);
end

function bounds = bundleBounds(b)
if isfield(b, 'Bounds')
    bounds = double(b.Bounds);
elseif isfield(b, 'Model') && isfield(b.Model, 'Bounds')
    bounds = double(b.Model.Bounds);
else
    error('ABACUS:UnifiedMetadata', 'Saved model has no input bounds.');
end
assert(isequal(size(bounds), [3, 2]), ...
    'Saved model bounds must be a 3-by-2 matrix.');
end

function restoreState(oldPath, oldRng)
path(oldPath);
rng(oldRng);
end
