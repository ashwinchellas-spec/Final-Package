function gui_build_mission_tab(app,tab)
%GUI_BUILD_MISSION_TAB Presets, custom constraints, weights, ranking and eliminations.
% All altitude inputs are geometric m. Zero maximum limits mean unconstrained.
g=uigridlayout(tab,[5,1]); g.RowHeight={35,125,78,45,'1x'};
t=app.DT.Database.read('Mission_Profiles');
app.Controls.MissionPreset=uidropdown(g,'Items',[cellstr(string(t.Mission_Name));{'Custom'}],...
    'ItemsData',[t.Mission_ID',0],'Value',1,'ValueChangedFcn',@(~,~) gui_action(app,'mission_preset'));
form=uigridlayout(g,[3,6]);
labels={'Altitude (m geometric)','Mach','Ceiling (m geometric)','Min thrust (kN)','Max dry mass (kg; 0 = none)','Min shaft power (kW)'};
for i=1:6, uilabel(form,'Text',labels{i},'WordWrap','on'); end
keys={'MissionAltitude','MissionMach','MissionCeiling','MissionThrust','MissionWeight','MissionPower'};
for i=1:6, app.Controls.(keys{i})=uieditfield(form,'numeric','Value',0,'Limits',[0,Inf]); end
uilabel(form,'Text','Max TSFC (kg/kN/h; 0 = none)','WordWrap','on');
app.Controls.MissionTSFC=uieditfield(form,'numeric','Value',0,'Limits',[0,Inf]);
uilabel(form,'Text','Max BSFC (kg/kW/h; 0 = none)','WordWrap','on');
app.Controls.MissionBSFC=uieditfield(form,'numeric','Value',0,'Limits',[0,Inf]);
app.Controls.MissionArchitecture=uidropdown(form,'Items',{'Turbofan_HighBPR','Turbojet,Turbofan_LowBPR','Turboprop','Piston'});
uilabel(form,'Text','Constraints apply before scoring.','WordWrap','on');
weights=uigridlayout(g,[2,5]); names={'Thrust','Efficiency','Fuel SFC','Altitude','Engine TWR'};
for i=1:5, uilabel(weights,'Text',[names{i},' weight']); end
app.Controls.Weights=gobjects(1,5);
for i=1:5, app.Controls.Weights(i)=uieditfield(weights,'numeric','Limits',[0,1],'Value',.2); end
bar=uigridlayout(g,[1,2]); uibutton(bar,'Text','Select engines','ButtonPushedFcn',@(~,~) gui_action(app,'mission'));
app.Controls.MissionMessage=uilabel(bar,'Text','Five weights must sum to 1.0.','WordWrap','on');
app.Controls.MissionResults=uitable(g);
end
