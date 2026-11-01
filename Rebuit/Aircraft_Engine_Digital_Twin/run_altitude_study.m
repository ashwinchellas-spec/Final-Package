function output = run_altitude_study(altitudes_m, mach, throttle, engineIDs, makePlots, storeResults, outputFolder, databaseFile)
%RUN_ALTITUDE_STUDY Compare catalogue engines at common geometric altitudes.
% Defaults: 0:1000:15000 m, Mach 0.3, throttle 1, all 13 catalogue engines.
% CSV/MAT outputs include invalid points and reasons. Plot gaps preserve limits.
% Valid results and execution logs are stored in SQLite by default.
if nargin < 1, altitudes_m = 0:1000:15000; end
if nargin < 2, mach = 0.3; end
if nargin < 3, throttle = 1; end
if nargin < 4, engineIDs = []; end
if nargin < 5, makePlots = true; end
if nargin < 6, storeResults = true; end
validateattributes(altitudes_m,{'numeric'},{'vector','nonempty','real','finite','>=',0,'<=',32000});
validateattributes(mach,{'numeric'},{'scalar','real','finite','>=',0,'<=',3});
validateattributes(throttle,{'numeric'},{'scalar','real','finite','>=',0,'<=',1});
validateattributes(makePlots,{'numeric','logical'},{'scalar','binary'});
validateattributes(storeResults,{'numeric','logical'},{'scalar','binary'});
altitudes_m = unique(altitudes_m(:));
if nargin < 8
    p = setup_project();
else
    p = setup_project(databaseFile);
end
db_seed_piston_extension(p.database_file);
if nargin < 7 || isempty(outputFolder)
    % tempname provides a unique run folder without overwriting earlier studies.
    outputFolder = tempname(p.results);
end
if ~isfolder(outputFolder), mkdir(outputFolder); end
dt = DT_Coordinator(p.database_file); cleanup = onCleanup(@() delete(dt));
catalogue = dt.Database.read('v_Engine_Catalogue');
if ~isempty(engineIDs)
    validateattributes(engineIDs,{'numeric'},{'vector','real','finite','integer','positive'});
    if any(~ismember(engineIDs,catalogue.Engine_ID))
        error('ABACUS:InvalidEngine','An engine ID is not in the catalogue. Run START_HERE(''catalogue'').');
    end
    catalogue = catalogue(ismember(catalogue.Engine_ID,engineIDs),:);
end
n = height(catalogue)*numel(altitudes_m);
rows = cell(n,1); rawResults = cell(n,1); k = 0;
for i = 1:height(catalogue)
    e = db_get_engine(dt.Database,catalogue.Engine_ID(i));
    fprintf('Engine %d/%d: %s\n',i,height(catalogue),e.Name);
    for j = 1:numel(altitudes_m)
        k = k+1;
        f = flight_condition(altitudes_m(j),mach,throttle,'geometric');
        r = simulate_engine(e,f); rawResults{k} = r;
        row = result_row(r);
        row.Manufacturer = string(catalogue.Manufacturer(i));
        a = ISA_model(altitudes_m(j),mach,'geometric');
        row.AmbientTemperature_K = a.T_K;
        row.AmbientPressure_Pa = a.P_Pa;
        row.AmbientDensity_kgm3 = a.Density_kgm3;
        row.FlightSpeed_ms = a.Velocity_ms;
        rows{k} = row;
    end
end
results = vertcat(rows{:});
summary = catalogue(:,{'Engine_ID','Designation','Manufacturer','Type_Name'});
summary.ValidPoints = zeros(height(summary),1);
summary.InvalidPoints = zeros(height(summary),1);
for i = 1:height(summary)
    selected = results.Engine_ID==summary.Engine_ID(i);
    summary.ValidPoints(i) = nnz(results.Valid(selected));
    summary.InvalidPoints(i) = nnz(~logical(results.Valid(selected)));
end
writetable(results,fullfile(outputFolder,'altitude_performance.csv'));
writetable(summary,fullfile(outputFolder,'engine_summary.csv'));
invalid = results(~logical(results.Valid),:);
writetable(invalid,fullfile(outputFolder,'invalid_operating_points.csv'));
settings = struct('GeometricAltitude_m',altitudes_m,'Mach',mach, ...
    'Throttle',throttle,'EngineIDs',catalogue.Engine_ID, ...
    'DataMeaning','Academic steady-state predictions; manufacturer accuracy not established.');
save(fullfile(outputFolder,'altitude_study.mat'),'results','summary','settings','rawResults');
write_text(fullfile(outputFolder,'READ_RESULTS.txt'),sprintf([ ...
    'These are academic model predictions, not measured engine tests.\n', ...
    'Altitude_m is geometric; engine limits are checked in geopotential metres.\n', ...
    'Mach and throttle are held fixed; true airspeed changes with ISA temperature.\n', ...
    'Invalid points remain in CSV with Valid=0 and reasons; plots show gaps.\n', ...
    'Compare jet thrust and TSFC within jet types, shaft power and BSFC within propeller types.\n', ...
    'TSFC_kgNs and BSFC_kgkWh have different units and cannot be directly ranked.\n', ...
    'Kaveri and optional piston records are estimates/assumptions, not verified variant data.\n']));
% Save portable outputs before DB writes so a persistence failure loses no calculations.
persistence = 'Not requested';
if storeResults
    try
        db_store_results(dt.Database,rawResults,'L2');
        persistence = 'Stored valid performance and all point logs in SQLite';
    catch exception
        persistence = ['FAILED: ',exception.message];
        write_text(fullfile(outputFolder,'database_error.txt'),getReport(exception,'extended','hyperlinks','off'));
        warning('ABACUS:StudyPersistence','CSV/MAT saved, but database write failed. See database_error.txt in %s.',outputFolder);
    end
end
write_text(fullfile(outputFolder,'database_status.txt'),persistence);
plotFiles = strings(0,1);
if makePlots
    try
        plotFiles = plot_altitude_study(results,outputFolder);
    catch exception
        write_text(fullfile(outputFolder,'plot_error.txt'),getReport(exception,'extended','hyperlinks','off'));
        warning('ABACUS:StudyPlot','Calculations saved, but plotting failed. See plot_error.txt in %s.',outputFolder);
    end
end
disp(summary);
fprintf('Actual calculation: %d valid / %d total points.\nResults: %s\nDatabase: %s\n',nnz(results.Valid),height(results),outputFolder,persistence);
output = struct('Results',results,'Summary',summary,'Folder',outputFolder, ...
    'DatabaseStatus',persistence,'PlotFiles',plotFiles);
end
