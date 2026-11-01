function selection = EngineSelector(dt,mission,engineIDs,persist)
%ENGINESELECTOR Apply hard filters, normalise survivors, then rank by weighted score.
% Inputs: DT handle, mission struct/ID, optional engine vector, persistence flag.
% Output: selection struct with survivors, elimination reasons and metric contributions.
% Ref: ABACUS 21. Engine-level TWR only; TP uses explicitly simulated static thrust.
if ~isstruct(mission), mission=load_mission(dt.Database,mission); end
weights=validate_mission(mission);
if nargin<3 || isempty(engineIDs), t=dt.Database.read('Engines'); engineIDs=t.Engine_ID; end
if nargin<4, persist=true; end
f=flight_condition(mission.Altitude_m,mission.Mach,1,'geopotential');
rows=cell(numel(engineIDs),1); constants=project_config();
for i=1:numel(engineIDs)
    e=db_get_engine(dt.Database,engineIDs(i)); r=simulate_engine(e,f); t=result_row(r);
    ceiling=simulate_engine(e,flight_condition(mission.Ceiling_m,mission.Mach,1,'geopotential'));
    t.Ceiling_OK=ceiling.Valid && ceiling.EquivalentThrust_N>0;
    t.DryWeight_kg=e.Params.DryWeight_kg; t.ModelCeiling_m=e.Params.MaxAltitude_m;
    if ismember(e.Type,{'Turboprop','Piston'})
        static=simulate_engine(e,flight_condition(0,0,1)); rated=static.EquivalentThrust_N;
        t.TWR_Basis="Simulated SLS equivalent thrust / dry engine weight";
    else
        rated=e.Params.Rated_Thrust_N; t.TWR_Basis="Catalogue dry rated thrust / dry engine weight";
    end
    t.Engine_TWR=rated/(e.Params.DryWeight_kg*constants.g0); rows{i}=t;
end
candidates=vertcat(rows{:}); [mask,reasons]=apply_hard_constraints(candidates,mission);
% Missing scoring inputs are also disqualifying, rather than silently imputed.
for i=1:height(candidates)
    if ~isfinite(candidates.Engine_TWR(i))
        mask(i)=false; reasons(i)=strtrim(reasons(i)+"; Missing TWR basis");
    end
end
candidates.EliminationReason=reasons;
valid=candidates(mask,:); excluded=candidates(~mask,:); ranking=table(); notes=strings(0,1);
if isempty(valid)
    message="No engine in the database meets all hard constraints for this mission. Relax one or more constraints to proceed.";
elseif height(valid)==1
    message="Only one engine meets all hard constraints; no comparative ranking is produced.";
else
    if all(ismember(string(valid.Architecture),["Turboprop","Piston"]))
        fuelMetric=valid.BSFC_kgkWh; fuelName='BSFC';
    else
        fuelMetric=valid.TSFC_kgNs; fuelName='TSFC';
    end
    metrics=[valid.EquivalentThrust_N,valid.Eta_thermal,fuelMetric,valid.ModelCeiling_m,valid.Engine_TWR];
    scores=zeros(size(metrics)); labels={'Thrust','Thermal efficiency',fuelName,'Model envelope ceiling','Engine TWR'};
    for j=1:5
        [scores(:,j),tied]=normalise_metric(metrics(:,j),j~=3);
        if tied, notes(end+1)="All feasible engines have identical "+labels{j}+"; this criterion does not differentiate candidates."; end
    end
    contributions=scores.*weights; ranking=valid;
    ranking.Score=sum(contributions,2);
    names={'Thrust_Contribution','Efficiency_Contribution','Fuel_Contribution','Altitude_Contribution','TWR_Contribution'};
    for j=1:5, ranking.(names{j})=contributions(:,j); end
    ranking=sortrows(ranking,'Score','descend'); ranking.Rank=(1:height(ranking))';
    message=ranking.Engine(1)+" has the highest score after all hard constraints; see the five contribution columns.";
end
selection=struct('Mission',mission,'Candidates',candidates,'Feasible',valid,'Eliminated',excluded,...
    'Ranking',ranking,'Message',message,'Notes',notes,'Weights',weights,...
    'Scope','Academic engine comparison; no aircraft drag, range or flight-planning model.');
if persist
    log=struct('Engine_ID',NaN,'DT_Level',"L4",'Model_Type',"Physics",...
        'Inputs_JSON',string(jsonencode(mission)),'Outputs_JSON',string(jsonencode(selection)),...
        'Model_Version',string(constants.Version),'Event_Type',"MissionSelection",'Timestamp_UTC',string(utc_timestamp()));
    dt.Database.append('Simulation_Log',struct2table(log));
end
end
