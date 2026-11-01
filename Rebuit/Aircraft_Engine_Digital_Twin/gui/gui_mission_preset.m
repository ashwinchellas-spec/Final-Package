function gui_mission_preset(app)
%GUI_MISSION_PRESET Copy a selected preset into editable controls with unit conversion.
% Input/output: app UI. This never runs selection or changes stored presets.
id=app.Controls.MissionPreset.Value; if id==0, return; end
m=load_mission(app.DT.Database,id); c=project_config();
app.Controls.MissionAltitude.Value=c.EarthRadius_m*m.Altitude_m/(c.EarthRadius_m-m.Altitude_m);
app.Controls.MissionMach.Value=m.Mach;
app.Controls.MissionCeiling.Value=c.EarthRadius_m*m.Ceiling_m/(c.EarthRadius_m-m.Ceiling_m);
app.Controls.MissionThrust.Value=m.Min_Thrust_N/1000;
app.Controls.MissionArchitecture.Value=char(string(m.Architectures));
names={'W_Thrust','W_Efficiency','W_Fuel','W_Altitude','W_TWR'};
for i=1:5, app.Controls.Weights(i).Value=m.(names{i}); end
app.Controls.MissionWeight.Value=0; app.Controls.MissionTSFC.Value=0;
app.Controls.MissionBSFC.Value=0; app.Controls.MissionPower.Value=0;
end
