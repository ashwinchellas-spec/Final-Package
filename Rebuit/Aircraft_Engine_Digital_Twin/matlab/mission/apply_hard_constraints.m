function [feasible,reasons] = apply_hard_constraints(candidates,mission)
%APPLY_HARD_CONSTRAINTS Eliminate each engine that fails any mandatory requirement.
% Inputs: evaluated candidate table, mission struct. Outputs: logical mask and reasons.
% Units: N, kg/(N s), kg/(kW h), kW, kg, m. Ref: ABACUS 21.1; no scoring here.
validate_mission(mission); n=height(candidates); feasible=true(n,1); reasons=strings(n,1);
architectures=strtrim(split(string(mission.Architectures),','));
for i=1:n
    problems=strings(0,1);
    if ~candidates.Valid(i), problems(end+1)="Invalid model operating point"; end
    if ~ismember(string(candidates.Architecture(i)),architectures), problems(end+1)="Architecture mismatch"; end
    if ~candidates.Ceiling_OK(i), problems(end+1)="Required altitude ceiling unavailable"; end
    rules={'Min_Thrust_N','EquivalentThrust_N','min';'Max_TSFC_kgNs','TSFC_kgNs','max';...
        'Min_Power_kW','ShaftPower_kW','min';'Max_BSFC_kgkWh','BSFC_kgkWh','max';...
        'Max_DryWeight_kg','DryWeight_kg','max'};
    for j=1:size(rules,1)
        field=rules{j,1};
        if ~isfield(mission,field) || isnan(mission.(field)), continue; end
        value=candidates.(rules{j,2})(i); limit=mission.(field);
        failed=~isfinite(value);
        if strcmp(rules{j,3},'min'), failed=failed || value<limit; else, failed=failed || value>limit; end
        if failed, problems(end+1)=string(field); end
    end
    feasible(i)=isempty(problems); reasons(i)=strjoin(problems,'; ');
end
end
