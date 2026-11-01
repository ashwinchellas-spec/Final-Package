function output = run_project(action)
%RUN_PROJECT Entry point for the ABACUS academic engineering application.
% Input: gui (default), demo, grid, validate, train or simulink. Output: action result.
% Requires MATLAB R2023b/Database Toolbox; ML and Simulink check their own dependencies.
if nargin<1, action='gui'; end
p=setup_project();
if strcmp(action,'gui'), output=EngineAnalyser_v1(p.database_file); return; end
dt=DT_Coordinator(p.database_file); cleanup=onCleanup(@() delete(dt));
switch lower(char(action))
    case 'demo'
        f=flight_condition(0,0,1); r=dt.run(4,f,'L4',true);
        if ~r.Valid, error('ABACUS:Demo','%s',strjoin(r.Warnings,' | ')); end
        comparison=compare_engines(dt,[4,5],f,'Thrust_N');
        selection=EngineSelector(dt,1,[],true);
        report=generate_report(r,comparison,selection,table());
        disp(format_result_metrics(r,'SI')); fprintf('Report: %s\n',report);
        output=struct('Result',r,'Comparison',comparison,'Selection',selection,'Report',report);
    case 'grid'
        engines=dt.Database.read('Engines'); parts=cell(height(engines),1);
        for i=1:height(engines)
            parts{i}=dt.map(engines.Engine_ID(i),true);
            writetable(parts{i},fullfile(p.tables,sprintf('engine_%d_grid.csv',engines.Engine_ID(i))));
        end
        output=vertcat(parts{:});
    case 'validate'
        output=validate_physics(p.database_file);
    case 'train'
        % User-facing training does not bypass current executed Track A validation.
        validate_physics(p.database_file); engines=dt.Database.read('Engines'); rows=cell(height(engines),1);
        for i=1:height(engines)
            id=engines.Engine_ID(i);
            try
                metrics=ml_train_surrogates(dt,id); status="PASS"; note="Training executed; inspect actual Track B acceptance metrics.";
                if ~all(metrics.MeetsAccuracyCriteria(metrics.Selected)), status="WARNING"; end
            catch exception
                status="WARNING"; note=string(exception.message);
            end
            rows{i}=table(id,status,note,'VariableNames',{'Engine_ID','ExecutionStatus','Diagnostic'});
        end
        output=vertcat(rows{:}); disp(output); writetable(output,fullfile(p.reports,'training_execution_status.csv'));
    case 'simulink'
        output=build_simulink_models(p.database_file);
    otherwise
        error('ABACUS:Action','Choose gui, demo, grid, validate, train or simulink.');
end
end
