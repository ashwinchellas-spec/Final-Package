% RUN_PENDING_STUDIES
% Complete the remaining input-coverage studies and refresh Track A status.
% The studies vary Mach and throttle independently while holding the other
% inputs fixed. They use the existing backend and do not fit parameters.

clearvars -except RUN_PENDING_STUDIES
close all

p = setup_project();
outputFolder = tempname(p.reports);
mkdir(outputFolder);

dt = DT_Coordinator(p.database_file);
cleanup = onCleanup(@() delete(dt));
catalogue = dt.Database.read('v_Engine_Catalogue');
engineIDs = catalogue.Engine_ID(:).';

% Mach study: sea level, full throttle. Invalid envelope points remain in
% the table and appear as gaps in the plots.
machValues = 0:0.1:2.0;
machTable = build_input_sweep(dt,engineIDs,'Mach',machValues,0,0.3,1);

% Throttle study: sea level, Mach 0.30. Low-throttle warnings are retained.
throttleValues = 0:0.1:1.0;
throttleTable = build_input_sweep(dt,engineIDs,'Throttle',throttleValues,0,0.3,1);

writetable(machTable,fullfile(outputFolder,'mach_comparison.csv'));
writetable(throttleTable,fullfile(outputFolder,'throttle_comparison.csv'));

summary = [summarise_sweep(machTable,'Mach'); ...
           summarise_sweep(throttleTable,'Throttle')];
writetable(summary,fullfile(outputFolder,'INPUT_STUDY_SUMMARY.csv'));

plot_sweep(machTable,'Mach',outputFolder);
plot_sweep(throttleTable,'Throttle',outputFolder);

% Refresh the independent-reference status after the input studies. This
% reports warnings/failures; it does not alter parameters or force a pass.
validation = run_project('validate');
trackA = table();
if isfield(validation,'TrackA') && istable(validation.TrackA)
    trackA = validation.TrackA;
    writetable(trackA,fullfile(outputFolder,'TRACK_A_VALIDATION.csv'));
end
save(fullfile(outputFolder,'pending_studies.mat'), ...
    'machTable','throttleTable','summary','trackA');

fprintf('\nPending studies complete.\nOutput folder:\n%s\n',outputFolder);
fprintf('Mach rows: %d (%d valid)\n',height(machTable),nnz(logical(machTable.Valid)));
fprintf('Throttle rows: %d (%d valid)\n',height(throttleTable),nnz(logical(throttleTable.Valid)));
fprintf('Reference status: inspect TRACK_A_VALIDATION.csv.\n');

function t = build_input_sweep(dt,engineIDs,axisName,values,altitude,mach,throttle)
rows = cell(numel(engineIDs)*numel(values),1);
k = 0;
for i = 1:numel(engineIDs)
    e = db_get_engine(dt.Database,engineIDs(i));
    for j = 1:numel(values)
        h = altitude;
        m = mach;
        q = throttle;
        switch axisName
            case 'Mach'
                m = values(j);
            case 'Throttle'
                q = values(j);
            otherwise
                error('ABACUS:InputStudyAxis','Unsupported study axis %s.',axisName);
        end
        r = simulate_engine(e,flight_condition(h,m,q,'geometric'));
        row = result_row(r);
        row.SweepAxis = string(axisName);
        row.SweepValue = values(j);
        rows{k+1} = row;
        k = k + 1;
    end
end
t = vertcat(rows{:});
end

function s = summarise_sweep(t,axisName)
ids = unique(t.Engine_ID,'stable');
rows = cell(numel(ids),1);
for i = 1:numel(ids)
    part = t(t.Engine_ID == ids(i),:);
    rows{i} = table(ids(i),string(part.Engine(1)),string(part.Architecture(1)), ...
        string(axisName),height(part),nnz(logical(part.Valid)), ...
        height(part)-nnz(logical(part.Valid)), ...
        'VariableNames',{'Engine_ID','Engine','Architecture','SweepAxis', ...
        'RequestedRows','ValidRows','InvalidRows'});
end
s = vertcat(rows{:});
end

function plot_sweep(t,axisName,outputFolder)
types = unique(string(t.Architecture),'stable');
for i = 1:numel(types)
    kind = types(i);
    part = t(string(t.Architecture) == kind,:);
    if ismember(kind,["Piston","Turboprop"])
        metrics = {'EquivalentThrust_N','FuelFlow_kgs','BSFC_kgkWh'};
        labels = {'Equivalent thrust (kN)','Fuel flow (kg/s)','BSFC (kg/kWh)'};
        scales = [1e-3,1,1];
        fileTag = 'propulsive';
    else
        metrics = {'EquivalentThrust_N','FuelFlow_kgs','TSFC_kgNs'};
        labels = {'Equivalent thrust (kN)','Fuel flow (kg/s)','TSFC (kg/(kN h))'};
        scales = [1e-3,1,3.6e6];
        fileTag = 'jet';
    end

    fig = figure('Visible','off','Color','w','Position',[100,100,1200,470]);
    tiled = tiledlayout(fig,1,3,'TileSpacing','compact','Padding','compact');
    title(tiled,sprintf('%s study | %s',axisName,kind),'Interpreter','none');
    subtitle(tiled,'Academic steady-state predictions; invalid envelope points are shown as gaps.');
    ids = unique(part.Engine_ID,'stable');
    for j = 1:numel(metrics)
        ax = nexttile(tiled);
        hold(ax,'on');
        for q = 1:numel(ids)
            e = part(part.Engine_ID == ids(q),:);
            if isempty(e), continue; end
            e = sortrows(e,'SweepValue');
            values = e.(metrics{j})*scales(j);
            values(~logical(e.Valid) | ~isfinite(values)) = NaN;
            plot(ax,e.SweepValue,values,'-o', ...
                'LineWidth',1.2,'MarkerSize',3,'DisplayName',char(e.Engine(1)));
        end
        xlabel(ax,axisName);
        ylabel(ax,labels{j});
        grid(ax,'on');
        if j == 1, legend(ax,'show','Location','best','Interpreter','none'); end
    end
    exportgraphics(fig,fullfile(outputFolder, ...
        sprintf('%s_%s_%s.png',lower(axisName),fileTag,matlab.lang.makeValidName(char(kind)))), ...
        'Resolution',160);
    close(fig);
end
end
