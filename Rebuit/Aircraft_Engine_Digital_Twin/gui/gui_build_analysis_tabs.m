function gui_build_analysis_tabs(app,tabs)
%GUI_BUILD_ANALYSIS_TABS Construct envelope, comparison and surrogate controls.
% Input: app and tabs; output: UI fields. Each button routes to an existing function.
g=uigridlayout(tabs{3},[3,1]); g.RowHeight={80,'1x',180};
bar=uigridlayout(g,[2,4]);
app.Controls.Axis=uidropdown(bar,'Items',{'GeopotentialAltitude_m','Mach','Throttle'});
app.Controls.Metric=uidropdown(bar,'Items',{'EquivalentThrust_N','Thrust_N','TSFC_kgNs','FuelFlow_kgs','ShaftPower_kW','BSFC_kgkWh','Eta_thermal'});
uibutton(bar,'Text','Run selected-axis sweep','ButtonPushedFcn',@(~,~) gui_action(app,'sweep'));
uibutton(bar,'Text','Generate full map','ButtonPushedFcn',@(~,~) gui_action(app,'map'));
uilabel(bar,'Text','Range minimum'); app.Controls.RangeMin=uieditfield(bar,'numeric','Value',0,'Limits',[0,32000]);
uilabel(bar,'Text','Range maximum'); app.Controls.RangeMax=uieditfield(bar,'numeric','Value',13000,'Limits',[0,32000]);
app.Controls.EnvelopeAxes=uiaxes(g); app.Controls.EnvelopeTable=uitable(g);
g=uigridlayout(tabs{4},[3,2]); g.RowHeight={105,'1x',180};
cat=app.DT.Database.read('v_Engine_Catalogue');
app.Controls.CompareIDs=uilistbox(g,'Items',cellstr(string(cat.Designation)),'ItemsData',cat.Engine_ID',...
    'Multiselect','on','Value',[4,5]);
bar=uigridlayout(g,[3,1]);
app.Controls.CompareMetric=uidropdown(bar,'Items',{'EquivalentThrust_N','Thrust_N','TSFC_kgNs','FuelFlow_kgs','ShaftPower_kW','BSFC_kgkWh'});
uibutton(bar,'Text','Compare selected engines at current inputs','ButtonPushedFcn',@(~,~) gui_action(app,'compare'));
uibutton(bar,'Text','Reference / physics / ML overlay for current engine','ButtonPushedFcn',@(~,~) gui_action(app,'overlay'));
app.Controls.CompareAxes=uiaxes(g); app.Controls.CompareAxes.Layout.Column=[1,2];
app.Controls.CompareTable=uitable(g); app.Controls.CompareTable.Layout.Column=[1,2];
g=uigridlayout(tabs{5},[4,1]); g.RowHeight={42,42,'1x',60};
bar=uigridlayout(g,[1,3]);
app.Controls.MLFamily=uidropdown(bar,'Items',{'Poly','RF','GPR','ANN'},'ValueChangedFcn',@(~,~) gui_action(app,'ml_metrics'));
uibutton(bar,'Text','Generate gated synthetic dataset','ButtonPushedFcn',@(~,~) gui_action(app,'dataset'));
uibutton(bar,'Text','Train and compare four families','ButtonPushedFcn',@(~,~) gui_action(app,'train'));
uibutton(g,'Text','Query selected operational surrogate (L5)','ButtonPushedFcn',@(~,~) gui_action(app,'predict'));
app.Controls.MLMetrics=uitable(g);
app.Controls.MLStatus=uilabel(g,'Text','No training has run in this session. Missing or unqualified models use physics fallback.', 'WordWrap','on');
end
