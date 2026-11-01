function gui_ml_action(app,action)
%GUI_ML_ACTION Execute gated dataset/training actions and show actual saved metrics.
% Input/output: app UI. Runs serially; missing validation is surfaced by gui_action.
id=app.Controls.Engine.Value; p=project_paths();
switch action
    case 'dataset'
        app.Controls.MLStatus.Text='Checking physics validation, then generating synthetic data...'; drawnow;
        data=ml_generate_dataset(app.DT,id);
        app.Controls.MLStatus.Text=sprintf('%d valid synthetic points. Split fractions: %.3f / %.3f / %.3f.',size(data.X,1),data.Split.ActualFractions);
    case 'train'
        app.Controls.MLStatus.Text='Checking validation and training four families; this can take several minutes.'; drawnow;
        t=ml_train_surrogates(app.DT,id); app.Controls.MLMetrics.Data=t; app.LastML=t;
        app.Controls.MLStatus.Text='Training/evaluation finished. Actual test metrics are shown; low-accuracy models stay unavailable to L5.';
    case 'ml_metrics'
        filename=fullfile(p.ml_models,sprintf('engine_%d_%s.mat',id,app.Controls.MLFamily.Value));
        if ~isfile(filename), error('ABACUS:MissingML','That surrogate has not been trained.'); end
        loaded=load(filename,'bundle'); app.Controls.MLMetrics.Data=loaded.bundle.TestMetrics;
end
end
