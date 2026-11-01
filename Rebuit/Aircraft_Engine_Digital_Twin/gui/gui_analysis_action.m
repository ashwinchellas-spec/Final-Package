function gui_analysis_action(app,action)
%GUI_ANALYSIS_ACTION Run current point/sweep/map/comparison through DT_Coordinator.
% GUI uses geometric metre input; grid axes use explicitly labelled geopotential metres.
id=app.Controls.Engine.Value;
f=flight_condition(app.Controls.Altitude.Value,app.Controls.Mach.Value,app.Controls.Throttle.Value);
e=db_get_engine(app.DT.Database,id);
switch action
    case {'physics','predict'}
        if strcmp(action,'predict'), level='L5'; else, level='L4'; end
        r=app.DT.run(id,f,level,true); app.LastResult=r; app.LastResults=result_row(r);
        app.Controls.Metrics.Data=format_result_metrics(r,app.Controls.Units.Value);
        app.Controls.Stations.Data=r.Stations;
        app.Controls.ResultSource.Text=sprintf('%s | %s | %s confidence',r.Status,r.Prediction_Source,r.Confidence);
        app.Controls.Banner.Text=char(strjoin(string(r.Warnings),' | '));
    case 'sweep'
        values=linspace(app.Controls.RangeMin.Value,app.Controls.RangeMax.Value,41);
        axis=app.Controls.Axis.Value; h=f.GeopotentialAltitude_m; m=f.Mach; theta=f.Throttle;
        switch axis
            case 'GeopotentialAltitude_m', h=values;
            case 'Mach', m=values;
            case 'Throttle', theta=values;
        end
        t=evaluate_grid(e,h,m,theta,app.DT.Database,false,'L2'); app.LastResults=t;
        app.Controls.EnvelopeTable.Data=t; plot_performance(t,axis,app.Controls.Metric.Value,app.Controls.EnvelopeAxes);
    case 'map'
        app.Controls.Banner.Text='Evaluating the architecture grid and retaining rejected-point diagnostics...'; drawnow;
        t=app.DT.map(id,true); app.LastResults=t; app.Controls.EnvelopeTable.Data=t;
        plot_performance_map(t,app.Controls.Metric.Value,1,app.Controls.EnvelopeAxes);
        app.Controls.Banner.Text=sprintf('%d valid / %d candidate points; estimated physics data.',nnz(t.Valid),height(t));
    case 'compare'
        t=compare_engines(app.DT,app.Controls.CompareIDs.Value,f,app.Controls.CompareMetric.Value);
        app.LastResults=t; app.Controls.CompareTable.Data=t; ax=app.Controls.CompareAxes; cla(ax);
        valid=logical(t.Valid); bar(ax,categorical(t.Engine(valid)),t.(app.Controls.CompareMetric.Value)(valid));
        ylabel(ax,strrep(app.Controls.CompareMetric.Value,'_',' ')); title(ax,'Same-condition academic comparison');
    case 'overlay'
        ref=app.DT.Database.read('v_Reference_Data'); ref=ref(ref.Engine_ID==id & ref.Afterburner==0,:);
        metric='Thrust_N'; if strcmp(e.Type,'Turboprop') || strcmp(e.Type,'Piston'), metric='ShaftPower_kW'; end
        ax=app.Controls.CompareAxes; cla(ax); hold(ax,'on');
        if ~isempty(ref)
            scatter(ax,ref.GeopotentialAltitude_m,ref.(metric),60,'DisplayName','Reference (source verification shown in table)');
            for i=1:height(ref)
                condition=flight_condition(ref.GeopotentialAltitude_m(i),ref.Mach(i),ref.Throttle(i),'geopotential');
                physics=app.DT.run(id,condition,'L1',false); model=app.DT.run(id,condition,'L5',false);
                scatter(ax,condition.GeopotentialAltitude_m,physics.(metric),45,'DisplayName','Physics, same reference condition');
                if strcmp(model.Prediction_Source,'ML'), scatter(ax,condition.GeopotentialAltitude_m,model.(metric),45,'DisplayName','ML, same reference condition'); end
            end
        end
        hold(ax,'off'); xlabel(ax,'Geopotential altitude (m)'); ylabel(ax,strrep(metric,'_',' ')); legend(ax,'Location','best');
        app.Controls.CompareTable.Data=ref;
end
if e.IsKaveri, c=project_config(); app.Controls.Banner.Text=[app.Controls.Banner.Text,' | ',c.KaveriWarning]; end
end
