function gui_export_action(app,action)
%GUI_EXPORT_ACTION Save actual session artifacts and switch verified database connections.
% Inputs: app, action. Output: CSV/MAT/PNG/PDF/HTML files. Cancellation is non-destructive.
p=project_paths();
switch action
    case 'database'
        file=app.Controls.DatabasePath.Value; db_initialize(file); db_seed(file);
        replacement=DT_Coordinator(file); previous=app.DT; app.DT=replacement; delete(previous);
        t=app.DT.Database.read('v_Engine_Catalogue'); app.Controls.Catalogue.Data=t;
        app.Controls.Engine.ItemsData=[]; app.Controls.Engine.Items=cellstr(string(t.Designation));
        app.Controls.Engine.ItemsData=t.Engine_ID'; app.Controls.Engine.Value=t.Engine_ID(1); gui_refresh_engine(app);
    case 'units'
        if isfield(app.LastResult,'Condition'), app.Controls.Metrics.Data=format_result_metrics(app.LastResult,app.Controls.Units.Value); end
    case 'csv'
        if isempty(app.LastResults), error('ABACUS:NoExportData','Run an analysis before exporting.'); end
        [name,folder]=uiputfile('*.csv','Save results',fullfile(p.tables,'results.csv'));
        if isequal(name,0), return; end
        writetable(app.LastResults,fullfile(folder,name));
    case 'mat'
        [name,folder]=uiputfile('*.mat','Save session',fullfile(p.results,'session.mat'));
        if isequal(name,0), return; end
        result=app.LastResult; results=app.LastResults; selection=app.LastSelection; ml=app.LastML; %#ok<NASGU>
        save(fullfile(folder,name),'result','results','selection','ml');
    case {'png','pdf'}
        [name,folder]=uiputfile(['*.',action],'Save plot',fullfile(p.plots,['performance.',action]));
        if isequal(name,0), return; end
        exportgraphics(app.Controls.EnvelopeAxes,fullfile(folder,name),'Resolution',200);
    case 'report'
        file=generate_report(app.LastResult,app.LastResults,app.LastSelection,app.LastML);
        app.Controls.Banner.Text=['Report created: ',file];
    case 'verify'
        t=verify_project(app.DT.DatabaseFile); app.Controls.Validation.Data=t;
end
end
