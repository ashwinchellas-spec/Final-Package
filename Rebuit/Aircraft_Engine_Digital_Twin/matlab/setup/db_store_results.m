function db_store_results(db, results, level)
%DB_STORE_RESULTS Atomically persist valid performance and all execution diagnostics.
% Inputs: DB handle, result cell array, DT level. Output: appended database records.
% Ref: ABACUS 19. Invalid results go to Simulation_Log only; references are immutable.
if ~iscell(results), results={results}; end
performance=cell(0,1); logs=cell(numel(results),1);
for i=1:numel(results)
    r=results{i}; t=result_row(r);
    if r.Valid
        t=removevars(t,{'Engine','Architecture','Eta_overall','Status','Error_Code'});
        performance{end+1,1}=t; %#ok<AGROW>
    end
    f=r.Condition;
    log=struct('Engine_ID',r.Engine_ID,'DT_Level',string(level),...
        'Model_Type',string(r.Prediction_Source),'ML_Model_Name',string(r.ML_Model_Type),...
        'Altitude_m',f.Altitude_m,'Mach',f.Mach,'Throttle',f.Throttle,...
        'Inputs_JSON',string(jsonencode(f)),'Outputs_JSON',string(jsonencode(r)),...
        'Exec_Time_ms',r.Elapsed_ms,'Model_Version',string(r.Model_Version),...
        'Model_Fingerprint',string(r.Model_Fingerprint),'Timestamp_UTC',string(r.Timestamp_UTC));
    logs{i}=struct2table(log);
end
if isempty(performance), p=table(); else, p=vertcat(performance{:}); end
l=vertcat(logs{:});
db.atomic(@() append_both(db,p,l));
end
function append_both(db,p,l)
%APPEND_BOTH Commit helper; typed tables and SI fields; transaction owner is caller.
if ~isempty(p), db.append('Performance_Data',p); end
db.append('Simulation_Log',l);
end
