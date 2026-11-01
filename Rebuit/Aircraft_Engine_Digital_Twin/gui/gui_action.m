function gui_action(app,action)
%GUI_ACTION Catch user-facing callback errors and dispatch to functional backend modules.
% Input: app and closed action string. Output: updated UI/files; no duplicated equations.
try
    switch action
        case 'filter'
            t=app.DT.Database.read('v_Engine_Catalogue'); kind=app.Controls.Architecture.Value;
            if ~strcmp(kind,'All'), t=t(string(t.Type_Name)==kind,:); end
            if isempty(t), error('ABACUS:NoEngines','No engines in that architecture. Run the optional piston seed if needed.'); end
            app.Controls.Catalogue.Data=t; app.Controls.Engine.ItemsData=[];
            app.Controls.Engine.Items=cellstr(string(t.Designation));
            app.Controls.Engine.ItemsData=t.Engine_ID'; app.Controls.Engine.Value=t.Engine_ID(1); gui_refresh_engine(app);
        case 'engine', gui_refresh_engine(app);
        case 'sources'
            p=project_paths(); open(fullfile(p.docs,'ABACUS_specification_v1_1.pdf'));
        case {'physics','predict','sweep','map','compare','overlay'}, gui_analysis_action(app,action);
        case {'dataset','train','ml_metrics'}, gui_ml_action(app,action);
        case 'mission_preset', gui_mission_preset(app);
        case 'mission', gui_mission_action(app);
        case 'validate'
            app.Controls.Banner.Text='Executing physics tests and reference comparisons...'; drawnow;
            v=validate_physics(app.DT.DatabaseFile); app.Controls.Validation.Data=v.TrackA;
            app.Controls.Banner.Text='Validation run finished. Inspect actual PASS / FAIL / WARNING rows in tab 7.';
        case {'database','units','csv','mat','png','pdf','report','verify'}, gui_export_action(app,action);
        otherwise, error('ABACUS:GUIAction','Unknown action %s.',action);
    end
catch exception
    e=[];
    try, e=db_get_engine(app.DT.Database,app.Controls.Engine.Value); catch, end
    message=string(exception.message);
    if ~isempty(e) && e.IsKaveri, c=project_config(); message=message+" | "+c.KaveriWarning; end
    app.Controls.Banner.Text=char(message); app.Controls.Banner.FontColor=[.70,.08,.08];
    uialert(app.UIFigure,char(message),'ABACUS diagnostic','Icon','warning');
end
end
