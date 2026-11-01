function output = RUN_TURBOPROP_REVIEW(projectRoot)
%RUN_TURBOPROP_REVIEW Apply a sourced PW127G rating correction and audit cycles.
% Select the existing rebuilt project; no physics equations are replaced.
% Old immutable performance references and existing simulation records remain.
% Exact source/rating review is documented in README.md beside this file.
if nargin < 1
    projectRoot = uigetdir(pwd,'Select Aircraft_Engine_Digital_Twin (contains START_HERE.m)');
    if isequal(projectRoot,0), output = []; return; end
end
if ~isfile(fullfile(projectRoot,'START_HERE.m'))
    error('ABACUS:Folder','Choose the rebuilt project root containing START_HERE.m.');
end
cd(projectRoot); addpath(projectRoot,genpath(fullfile(projectRoot,'matlab')),'-begin');
p = project_paths();
if isempty(which('db_sql_mode')) || isempty(which('db_read_sqlite'))
    error('ABACUS:DatabaseFix','Install the database compatibility fix before this review.');
end
if ~isfolder(p.reports), mkdir(p.reports); end
folder = tempname(p.reports); mkdir(folder);
try
    output = do_review(p,folder);
catch exception
    write_text(fullfile(folder,'review_error.txt'),getReport(exception,'extended','hyperlinks','off'));
    fprintf('Review diagnostic saved in %s\n',folder);
    rethrow(exception);
end
end
function output = do_review(p,folder)
db = DB_Interface(p.database_file); cleanup = onCleanup(@() delete(db));
% Save affected tables BEFORE any database change. This is an audit snapshot,
% not a full database backup; the SQL update below is atomic.
before = struct('Parameters',db.read('Engine_Thermo_Params'), ...
    'Provenance',db.read('Parameter_Provenance'),'References',db.read('References'), ...
    'Performance',db.read('Performance_Data'));
save(fullfile(folder,'before_source_update.mat'),'before');
source = 'https://www.easa.europa.eu/en/downloads/7725/en#page=10';
tag = 'EASA_IM_E041_ISSUE07_PW127G_REVIEW';
note = ['EASA IM.E.041 Issue 07, 20 December 2023, page 10 PW127G row: ', ...
    'maximum take-off and maximum continuous shaft power 2178 kW; normal take-off 1973 kW. ', ...
    'Page 17 Note 1: dry sea-level static ICAO atmosphere, no external accessory load or bleed. ', ...
    'Throttle=1 is the model full-power comparison convention, not a certified control schedule.'];
parts = { ...
    ['INSERT OR IGNORE INTO "References" (Short_Tag,Authors,Title,Publisher,Year,Source_Type,URL_DOI,Notes) VALUES (', ...
     literal(tag),',''EASA'',''TCDS IM.E.041 Issue 07 - PW100 series engines'',''EASA'',2023,''Type_Certificate'',', ...
     literal(source),',',literal(note),');'], ...
    'UPDATE Engine_Thermo_Params SET Rated_Power_kW=2178 WHERE Engine_ID=10;', ...
    ['UPDATE Parameter_Provenance SET Parameter_Value=2178,Unit=''kW'',Source_Type=''Type_Certificate'',', ...
     'Confidence_Level=''High'',Verified=1,Ref_ID=(SELECT Ref_ID FROM "References" WHERE Short_Tag=',literal(tag),'),', ...
     'Source_Reference=',literal(source),',Notes=',literal(note), ...
     ' WHERE Engine_ID=10 AND Parameter_Name=''Rated_Power_kW'';'], ...
    ['INSERT INTO Performance_Data (Engine_ID,Data_Type,Altitude_m,GeopotentialAltitude_m,Mach,Throttle,Afterburner,', ...
     'ShaftPower_kW,Source_Ref,Reference_Kind,Reference_Verified,Confidence,Prediction_Source,Warnings) ', ...
     'SELECT 10,''Reference'',0,0,0,1,0,2178,',literal(source), ...
     ',''PublishedRating'',1,''High'',''Reference'',',literal(note), ...
     ' WHERE NOT EXISTS (SELECT 1 FROM Performance_Data WHERE Engine_ID=10 AND Data_Type=''Reference'' AND Source_Ref=',literal(source),');']};
script = fullfile(folder,'reviewed_reference_update.sql');
write_text(script,strjoin(parts,sprintf('\n-- @statement\n')));
db_execute_script(db.Connection,script);
% A verified rating does not verify the other model inputs.
updated = db_get_engine(db,10);
assert(updated.Params.Rated_Power_kW==2178,'Rated power update was not applied.');
baselineRows = cell(3,1); sensitivity = cell(0,1);
ids = [9,10,11]; f = flight_condition(0,0,1,'geometric');
for j = 1:numel(ids)
    e = db_get_engine(db,ids(j)); r = simulate_engine(e,f);
    if ~r.Valid, error('ABACUS:ReviewPoint','%s: %s',e.Name,strjoin(r.Warnings,' | ')); end
    d = r.Diagnostics;
    baselineRows{j} = table(e.ID,string(e.Name),r.ShaftPower_kW,e.Params.Rated_Power_kW, ...
        e.Params.MassFlow_kgs,e.Params.T_t4_K,e.Params.OPR, ...
        r.FuelFlow_kgs,r.BSFC_kgkWh,d.CompressorWork_Jkg,d.GasGeneratorPower_W, ...
        d.MassResidual_kgs,d.BurnerResidual_W,d.ShaftResidual_W, ...
        'VariableNames',{'Engine_ID','Engine','PredictedPower_kW','CatalogueRating_kW', ...
        'InputMassFlow_kgs','InputTIT_K','InputOPR','FuelFlow_kgs','BSFC_kgkWh', ...
        'CompressorWork_Jkg','PowerBeforeGearbox_W','MassResidual_kgs','BurnerResidual_W','ShaftResidual_W'});
    writetable(r.Stations,fullfile(folder,sprintf('engine_%d_stations.csv',e.ID)));
    writetable(e.Provenance,fullfile(folder,sprintf('engine_%d_input_sources.csv',e.ID)));
    % Local one-at-a-time sensitivities: DO NOT write changed parameters to DB.
    fields = {'MassFlow_kgs','T_t4_K','OPR','Eta_power_turbine','PowerTurbine_BackPressure_Ratio'};
    for k = 1:numel(fields)
        key = fields{k};
        for fraction = [-0.02,0.02]
            candidate = e; candidate.Params.(key) = e.Params.(key)*(1+fraction);
            candidate.Fingerprint = 'DIAGNOSTIC-ONLY-NOT-FOR-VALIDATION-OR-ML';
            candidate.Estimated = true;
            trial = simulate_engine(candidate,f);
            change = 100*(trial.ShaftPower_kW/r.ShaftPower_kW-1);
            sensitivity{end+1,1} = table(e.ID,string(e.Name),string(key),fraction*100, ...
                candidate.Params.(key),trial.ShaftPower_kW,change,logical(trial.Valid), ...
                strjoin(string(trial.Warnings),' | '), ...
                'VariableNames',{'Engine_ID','Engine','Parameter','InputChangePercent','TrialValue', ...
                'PredictedPower_kW','PowerChangePercent','Valid','Warnings'}); %#ok<AGROW>
        end
    end
end
baseline = vertcat(baselineRows{:}); trials = vertcat(sensitivity{:});
writetable(baseline,fullfile(folder,'turboprop_baseline.csv'));
writetable(trials,fullfile(folder,'turboprop_sensitivity.csv'));
comparison = validate_references(db,[9,10,11]);
writetable(comparison,fullfile(folder,'reviewed_reference_comparison.csv'));
save(fullfile(folder,'turboprop_review.mat'),'baseline','trials','comparison');
disp(baseline(:,{'Engine','PredictedPower_kW','CatalogueRating_kW','InputMassFlow_kgs','InputTIT_K','InputOPR'}));
fprintf('\nPW127G reference corrected to 2178 kW; physics inputs were not fitted.\n');
fprintf('Source verification applies only to the reviewed rating. Overall confidence remains Low.\n');
fprintf('No validation certificate was accepted and no ML model was trained by this review.\n');
fprintf('Send turboprop_review.mat or the three summary CSVs from:\n%s\n',folder);
output = struct('Folder',folder,'Baseline',baseline,'Sensitivity',trials,'Comparison',comparison);
end
function value = literal(text)
%LITERAL SQL literal quoting for fixed reviewed metadata, not raw SQL input.
value = ['''',strrep(char(text),'''',''''''),''''];
end
