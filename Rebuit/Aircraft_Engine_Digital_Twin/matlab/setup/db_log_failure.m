function db_log_failure(db,requestedID,f,level,exception)
%DB_LOG_FAILURE Record a rejected coordinator request without violating foreign keys.
% Inputs: DB, original engine selector/flight object, level, exception. Output: log row.
% Unknown engine IDs use NULL; the original selector remains in Inputs_JSON.
c=project_config(); input=struct('RequestedEngine',requestedID,'Condition',f);
output=struct('Status','FAIL','Error_Code',exception.identifier,'Message',exception.message);
row=struct('Engine_ID',NaN,'DT_Level',string(level),'Model_Type',"Physics",...
    'Inputs_JSON',string(jsonencode(input)),'Outputs_JSON',string(jsonencode(output)),...
    'Model_Version',string(c.Version),'Event_Type',"RejectedRequest",'Timestamp_UTC',string(utc_timestamp()));
db.append('Simulation_Log',struct2table(row));
end
