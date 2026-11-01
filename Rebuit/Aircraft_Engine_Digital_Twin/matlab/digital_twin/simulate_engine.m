function r = simulate_engine(e,f)
%SIMULATE_ENGINE Route the architecture and convert cycle errors to visible results.
% Inputs: loaded engine and flight structs. Output: standard result r, including FAIL.
% Units: SI. Missing DB IDs fail before this function; no numeric result on failure.
r = result_template(e,f); runTimer = tic;
try
    switch e.Type
        case 'Turbojet', r = TJ_Model(e,f);
        case {'Turbofan_HighBPR','Turbofan_LowBPR'}, r = TF_Model(e,f);
        case 'Turboprop', r = TP_Model(e,f);
        case 'Piston', r = Piston_Model(e,f);
        otherwise, error('ABACUS:MissingModel','No model exists for architecture %s.',e.Type);
    end
catch exception
    r.Status='FAIL'; r.Valid=false; r.Error_Code=exception.identifier;
    r.Warnings(end+1)=string(exception.message);
    if e.IsKaveri, c=project_config(); r.Warnings(end+1)=string(c.KaveriWarning); end
end
r.Elapsed_ms = toc(runTimer)*1000;
end
