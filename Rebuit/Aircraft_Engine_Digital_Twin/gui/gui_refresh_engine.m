function gui_refresh_engine(app)
%GUI_REFRESH_ENGINE Load provenance and show permanent estimate/envelope warnings.
% Input: app. Output: controls. Units: backend SI; limits shown as geometric altitude.
e=db_get_engine(app.DT.Database,app.Controls.Engine.Value); p=e.Params; c=project_config();
app.Controls.Provenance.Data=e.Provenance; app.Controls.Provenance.ColumnName=e.Provenance.Properties.VariableNames;
removeStyle(app.Controls.Provenance);
low=find(string(e.Provenance.Confidence_Level)=="Low");
if ~isempty(low), addStyle(app.Controls.Provenance,uistyle('BackgroundColor',[1,.94,.80]),'row',low); end
maxGeometric=min(32000,c.EarthRadius_m*p.MaxAltitude_m/(c.EarthRadius_m-p.MaxAltitude_m));
app.Controls.Altitude.Value=min(app.Controls.Altitude.Value,maxGeometric); app.Controls.Altitude.Limits=[0,maxGeometric];
app.Controls.Mach.Value=min(app.Controls.Mach.Value,p.MaxMach); app.Controls.Mach.Limits=[0,p.MaxMach];
app.Controls.RangeMax.Value=p.MaxAltitude_m;
message=sprintf('%s | %s confidence | H envelope 0-%.0f m; Mach 0-%.2f | Estimated academic parameters',e.Name,e.Confidence,p.MaxAltitude_m,p.MaxMach);
if e.IsKaveri, message=[message,' | ',c.KaveriWarning]; end
app.Controls.Banner.Text=message;
app.Controls.Banner.FontColor=[.42,.23,.03];
app.Controls.ResultSource.Text='Select Run to evaluate this engine.';
app.LastResult=struct(); app.Controls.Metrics.Data=table(); app.Controls.Stations.Data=table();
gui_mission_preset(app);
end
