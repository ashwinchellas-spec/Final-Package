function report = validate_references(db,engineIDs)
%VALIDATE_REFERENCES Track A: compare exact reference conditions without fitting.
% Inputs: DB handle, optional IDs. Output: table of actual errors/status/source confidence.
% SI units; ABACUS Table 23.1. Unverified references and AB cases cannot receive PASS.
engines=db.read('Engines');
if nargin<2, engineIDs=engines.Engine_ID; end
refs=db.read('v_Reference_Data'); refs=refs(ismember(refs.Engine_ID,engineIDs),:);
p=project_paths(); policy=readtable(fullfile(p.database,'reference_policy.csv'));
parts=cell(height(refs),1);
for i=1:height(refs)
    ref=refs(i,:); e=db_get_engine(db,ref.Engine_ID);
    rule=policy.Tolerance_Fraction(policy.Engine_ID==e.ID);
    if isempty(rule), rule=.15; end
    if isfinite(ref.Thrust_N), metric='Thrust_N'; value=ref.Thrust_N; else, metric='ShaftPower_kW'; value=ref.ShaftPower_kW; end
    result=simulate_engine(e,flight_condition(ref.GeopotentialAltitude_m,ref.Mach,ref.Throttle,'geopotential',ref.Afterburner));
    actual=result.(metric); discrepancy=100*abs(actual-value)/abs(value);
    status="WARNING"; reason="Unverified secondary/estimated source; numerical comparison is not manufacturer validation.";
    if ref.Afterburner
        reason="Afterburner reference retained for traceability but outside implemented scope.";
    elseif ~result.Valid
        status="FAIL"; reason=strjoin(result.Warnings,' | ');
    elseif ref.Reference_Verified
        if discrepancy<=100*rule, status="PASS"; reason="Within configured tolerance at the stated independently verified condition.";
        else, status="FAIL"; reason="Prediction outside stated reference tolerance; no parameter fitting performed."; end
        if string(ref.Reference_Kind)=="EstimatedTarget"
            reason="Academic estimated-target comparison only, not manufacturer/measurement validation. "+reason;
        end
    end
    parts{i}=table(e.ID,string(e.Name),ref.Data_ID,string(metric),value,actual,discrepancy,100*rule,...
        logical(ref.Reference_Verified),status,string(reason),string(ref.Source_Ref),string(ref.Confidence),...
        'VariableNames',{'Engine_ID','Engine','Data_ID','Metric','ReferenceValue','SimulatedValue',...
        'RelativeErrorPercent','TolerancePercent','SourceVerified','Status','Reason','Source','Confidence'});
end
if isempty(parts), report=table(); else, report=vertcat(parts{:}); end
end
