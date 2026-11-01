function gui_mission_action(app)
%GUI_MISSION_ACTION Read custom constraints and show survivors plus eliminated engines.
% Inputs: app controls in labelled display units. Output: rankings without bypassing filters.
f=flight_condition(app.Controls.MissionAltitude.Value,app.Controls.MissionMach.Value,1);
ceiling=flight_condition(app.Controls.MissionCeiling.Value,0,1);
m=struct('Mission_ID',0,'Mission_Name','GUI custom / edited preset','Category','Custom',...
    'Architectures',app.Controls.MissionArchitecture.Value,'Altitude_m',f.GeopotentialAltitude_m,...
    'Ceiling_m',ceiling.GeopotentialAltitude_m,'Mach',f.Mach,'Min_Thrust_N',1000*app.Controls.MissionThrust.Value,...
    'Min_Power_kW',app.Controls.MissionPower.Value,'Max_TSFC_kgNs',app.Controls.MissionTSFC.Value/3.6e6,...
    'Max_BSFC_kgkWh',app.Controls.MissionBSFC.Value,'Max_DryWeight_kg',app.Controls.MissionWeight.Value);
for name=["Min_Power_kW","Max_TSFC_kgNs","Max_BSFC_kgkWh","Max_DryWeight_kg"]
    if m.(name)==0, m.(name)=NaN; end
end
names={'W_Thrust','W_Efficiency','W_Fuel','W_Altitude','W_TWR'};
for i=1:5, m.(names{i})=app.Controls.Weights(i).Value; end
s=EngineSelector(app.DT,m,[],true); app.LastSelection=s; app.Controls.MissionMessage.Text=char(s.Message);
if isempty(s.Ranking)
    t=s.Candidates; t.Score=nan(height(t),1);
else
    t=s.Candidates; t.Score=nan(height(t),1);
    for i=1:height(s.Ranking), t.Score(t.Engine_ID==s.Ranking.Engine_ID(i))=s.Ranking.Score(i); end
end
app.LastResults=t; app.Controls.MissionResults.Data=t;
removeStyle(app.Controls.MissionResults); rows=find(strlength(t.EliminationReason)>0);
if ~isempty(rows), addStyle(app.Controls.MissionResults,uistyle('BackgroundColor',[.90,.90,.90]),'row',rows); end
if any(contains(string(t.Engine),'Kaveri'))
    c=project_config(); app.Controls.Banner.Text=c.KaveriWarning;
end
end
