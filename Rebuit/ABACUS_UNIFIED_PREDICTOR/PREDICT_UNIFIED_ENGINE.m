function predictions = PREDICT_UNIFIED_ENGINE(registry, engineID, X)
%PREDICT_UNIFIED_ENGINE Query any registered engine with [altitude Mach throttle].
% This is a guarded experimental predictor. It checks bounds, source fingerprint,
% simulator validity and finite/nonnegative outputs. It does not certify engines.
validateattributes(engineID, {'numeric'}, {'scalar', 'integer', '>=', 1, '<=', 13});
validateattributes(X, {'numeric'}, {'2d', 'real', 'finite', 'ncols', 3, 'nonempty'});
assert(isstruct(registry) && isfield(registry, 'Entries'), ...
    'Build a registry first with BUILD_UNIFIED_REGISTRY.');
entry = registry.Entries([registry.Entries.Engine_ID] == engineID);
assert(numel(entry) == 1, 'Engine ID %d is not in the registry.', engineID);
loaded = load(char(entry.ModelFile), 'bundle');
b = loaded.bundle;
assert(~b.Operational && b.EngineSnapshot.ID == engineID, ...
    'This predictor accepts only the saved experimental model bundle.');
oldPath = path;
oldRng = rng;
cleanup = onCleanup(@() restoreState(oldPath, oldRng)); %#ok<NASGU>
addpath(char(b.ProjectRoot), genpath(fullfile(char(b.ProjectRoot), 'matlab')), '-begin');
% Database cleanup occurs inside this function before the outer path is restored.
predictions = queryWithinProject(b, X);
end

function predictions = queryWithinProject(b, X)
p = project_paths();
assert(strcmpi(char(p.root), char(b.ProjectRoot)), 'Another project copy is active.');
db = DB_Interface(p.database_file);
closeDB = onCleanup(@() delete(db)); %#ok<NASGU>
e = db_get_engine(db, b.EngineSnapshot.ID);
assert(strcmp(e.Fingerprint, b.Fingerprint), ...
    'Source or parameters changed; this saved model is stale.');

[bounds, featureNames, targetNames] = bundleMetadata(b);

inBox = all(X >= bounds(:, 1)' & X <= bounds(:, 2)', 2);
Y = NaN(size(X, 1), numel(targetNames));
available = false(size(X, 1), 1);
note = repmat("Outside saved model bounds", size(X, 1), 1);
for i = find(inBox)'
    physics = simulate_engine(e, flight_condition(X(i, 1), X(i, 2), ...
        X(i, 3), 'geometric'));
    if ~physics.Valid
        note(i) = "Simulator rejects this point: " + ...
            strjoin(string(physics.Warnings), ' | ');
        continue
    end
    value = evaluateBundle(b, X(i, :));
    if any(~isfinite(value)) || any(value <= 0)
        note(i) = "Invalid or nonpositive surrogate output";
        continue
    end
    Y(i, :) = value;
    available(i) = true;
    note(i) = "Experimental simulator approximation; local error is not guaranteed";
end
predictions = array2table([X, Y], 'VariableNames', ...
    [featureNames, targetNames]);
predictions.PredictionAvailable = available;
predictions.Note = note;
predictions.Engine_ID = repmat(b.EngineSnapshot.ID, size(X, 1), 1);
predictions.Engine = repmat(string(b.EngineSnapshot.Name), size(X, 1), 1);
predictions.ModelMode = repmat(string(b.Mode), size(X, 1), 1);
end

function [bounds, featureNames, targetNames] = bundleMetadata(b)
% Older saved bundles keep these fields inside the model or omit feature names.
if isfield(b, 'Bounds')
    bounds = double(b.Bounds);
elseif isfield(b, 'Model') && isfield(b.Model, 'Bounds')
    bounds = double(b.Model.Bounds);
else
    error('ABACUS:UnifiedMetadata', 'Saved model has no input bounds.');
end
if isfield(b, 'FeatureNames')
    featureNames = cellstr(string(b.FeatureNames));
else
    featureNames = {'Altitude_m', 'Mach', 'Throttle'};
end
if isfield(b, 'TargetNames')
    targetNames = cellstr(string(b.TargetNames));
elseif ismember(char(b.Mode), {'EXPERIMENTAL_J79_CHEB', ...
        'EXPERIMENTAL_BOUNDARY_REVISION'})
    targetNames = {'Thrust_N', 'FuelFlow_kgs', 'TSFC_kgNs'};
else
    error('ABACUS:UnifiedMetadata', 'Saved model has no target names.');
end
assert(size(bounds, 1) == 3 && size(bounds, 2) == 2, ...
    'Saved model bounds must be a 3-by-2 matrix.');
end

function value = evaluateBundle(b, X)
switch char(b.Mode)
    case 'EXPERIMENTAL_J79_CHEB'
        value = evaluateJ79Chebyshev(b.Model, X);
    case 'EXPERIMENTAL_BOUNDARY_REVISION'
        primary = ml_apply_candidate(b.Model.Core, X);
        if b.Model.LogTargets
            primary = exp(primary);
        end
        value = [primary, primary(:, 2) ./ primary(:, 1)];
    case 'EXPERIMENTAL_SIMULATOR_ONLY'
        value = ml_apply_candidate(b.Model, X);
    otherwise
        error('ABACUS:UnifiedMode', 'Unsupported model mode: %s', b.Mode);
end
end

function value = evaluateJ79Chebyshev(model, X)
z = 2 * (X - model.Bounds(:, 1)') ./ ...
    (model.Bounds(:, 2) - model.Bounds(:, 1))' - 1;
degree = double(model.Degree);
q = cell(1, 3);
for j = 1:3
    t = ones(size(X, 1), degree + 1);
    if degree >= 1
        t(:, 2) = z(:, j);
    end
    for k = 2:degree
        t(:, k + 1) = 2 * z(:, j) .* t(:, k) - t(:, k - 1);
    end
    q{j} = t;
end
powers = double(model.Powers) + 1;
design = q{1}(:, powers(:, 1)) .* q{2}(:, powers(:, 2)) .* ...
    q{3}(:, powers(:, 3));
primary = (design * model.Coefficients) .* model.OutputScale + model.OutputMean;
value = [primary, primary(:, 2) ./ primary(:, 1)];
end

function restoreState(oldPath, oldRng)
path(oldPath);
rng(oldRng);
end
