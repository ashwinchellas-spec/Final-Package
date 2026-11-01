function gui_build(app)
%GUI_BUILD Assemble eight tabs and common controls; all callbacks dispatch to backend.
% Input: AppBase app. Output: app.Controls/UI components. Units labelled at each control.
root=uigridlayout(app.UIFigure,[4,1]); root.RowHeight={58,42,'1x',38};
header=uigridlayout(root,[1,5]); header.ColumnWidth={260,90,200,60,'1x'};
uilabel(header,'Text','ABACUS ENGINE ANALYSER','FontWeight','bold','FontSize',19,'FontColor',[.05,.18,.30]);
uilabel(header,'Text','Architecture');
app.Controls.Architecture=uidropdown(header,'Items',{'All','Turbojet','Turbofan_HighBPR','Turbofan_LowBPR','Turboprop','Piston'},...
    'ValueChangedFcn',@(~,~) gui_action(app,'filter'));
uilabel(header,'Text','Engine');
catalogue=app.DT.Database.read('v_Engine_Catalogue');
app.Controls.Engine=uidropdown(header,'Items',cellstr(string(catalogue.Designation)),...
    'ItemsData',catalogue.Engine_ID','Value',4,'ValueChangedFcn',@(~,~) gui_action(app,'engine'));
app.Controls.Banner=uilabel(root,'Text','Academic estimates; validation status is shown in tab 7.','WordWrap','on',...
    'FontColor',[.42,.23,.03],'BackgroundColor',[1,.94,.80]);
group=uitabgroup(root);
app.Controls.TabGroup=group;
names={'Engine Database Browser','Single-Point Analysis','Performance Envelope (L2/L3)',...
    'Digital Twin Comparison','ML Surrogate Manager','Mission-Based Engine Selection','Validation Report','Settings and Export'};
tabs=cell(1,8);
for i=1:8, tabs{i}=uitab(group,'Title',names{i}); end
% Tab 1: catalogue and per-value provenance.
g=uigridlayout(tabs{1},[3,1]); g.RowHeight={'1x','2x',32};
app.Controls.Catalogue=uitable(g,'Data',catalogue,'ColumnName',catalogue.Properties.VariableNames);
app.Controls.Provenance=uitable(g); uibutton(g,'Text','Open the project specification and source notes','ButtonPushedFcn',@(~,~) gui_action(app,'sources'));
% Tab 2: single-point controls, metrics and station totals.
g=uigridlayout(tabs{2},[3,2]); g.RowHeight={96,'1x',32};
form=uigridlayout(g,[2,6]); form.Layout.Column=[1,2];
labels={'Geometric altitude (m)','Mach (-)','Throttle (0 to 1)'};
for i=1:3, uilabel(form,'Text',labels{i}); end
uibutton(form,'Text','Run physics (L4)','ButtonPushedFcn',@(~,~) gui_action(app,'physics'));
uibutton(form,'Text','Predict (L5)','ButtonPushedFcn',@(~,~) gui_action(app,'predict'));
uilabel(form,'Text','Model / source shown below');
app.Controls.Altitude=uieditfield(form,'numeric','Limits',[0,32000],'Value',0);
app.Controls.Mach=uieditfield(form,'numeric','Limits',[0,3],'Value',0);
app.Controls.Throttle=uieditfield(form,'numeric','Limits',[0,1],'Value',1);
app.Controls.ResultSource=uilabel(form,'Text','No calculation yet'); app.Controls.ResultSource.Layout.Column=[4,6];
app.Controls.Metrics=uitable(g); app.Controls.Stations=uitable(g);
label=uilabel(g,'Text','Steady-state model only - transient dynamics are not represented. Station table uses TOTAL K and Pa.'); label.Layout.Column=[1,2];
gui_build_analysis_tabs(app,tabs);
gui_build_mission_tab(app,tabs{6});
% Tab 7: real execution results, with no preloaded pass claims.
g=uigridlayout(tabs{7},[3,1]); g.RowHeight={38,35,'1x'};
uibutton(g,'Text','Run physics tests and Track A reference comparison','ButtonPushedFcn',@(~,~) gui_action(app,'validate'));
uilabel(g,'Text','Unverified reference points cannot receive PASS or open the default ML training gate.','WordWrap','on');
app.Controls.Validation=uitable(g);
% Tab 8: selected database and export controls.
g=uigridlayout(tabs{8},[7,2]); g.RowHeight={38,38,38,38,38,38,'1x'};
uilabel(g,'Text','Database path'); app.Controls.DatabasePath=uieditfield(g,'text','Value',app.DT.DatabaseFile);
uibutton(g,'Text','Connect to database','ButtonPushedFcn',@(~,~) gui_action(app,'database'));
app.Controls.Units=uidropdown(g,'Items',{'SI','Imperial'},'ValueChangedFcn',@(~,~) gui_action(app,'units'));
uibutton(g,'Text','Export current table (CSV)','ButtonPushedFcn',@(~,~) gui_action(app,'csv'));
uibutton(g,'Text','Export current session (MAT)','ButtonPushedFcn',@(~,~) gui_action(app,'mat'));
uibutton(g,'Text','Export analysis plot (PNG)','ButtonPushedFcn',@(~,~) gui_action(app,'png'));
uibutton(g,'Text','Export analysis plot (PDF)','ButtonPushedFcn',@(~,~) gui_action(app,'pdf'));
uibutton(g,'Text','Create session report (HTML)','ButtonPushedFcn',@(~,~) gui_action(app,'report'));
uibutton(g,'Text','Verify project installation','ButtonPushedFcn',@(~,~) gui_action(app,'verify'));
c=project_config(); label=uilabel(g,'Text',['Model: ',c.Version]); label.Layout.Column=[1,2];
label=uilabel(g,'Text','SI values are used internally and for CSV export. The display selector converts the single-point metrics. GUI altitude inputs remain geometric metres. No afterburner, transient, hardware or certification model.','WordWrap','on'); label.Layout.Column=[1,2];
uilabel(root,'Text','Academic steady-state software Digital Twin | Reference, physics and ML remain distinct | Source provenance is available in tab 1',...
    'FontColor',[.15,.25,.35],'WordWrap','on');
end
