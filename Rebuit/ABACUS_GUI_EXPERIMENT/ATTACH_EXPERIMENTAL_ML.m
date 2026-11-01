function tab = ATTACH_EXPERIMENTAL_ML(app, registry, predictorFile)
%ATTACH_EXPERIMENTAL_ML Add a separate experimental tab to an existing GUI.
% No source replacement, database writes, training or validation-gate changes.
assert(isvalid(app.UIFigure), 'Open the main application first.');
assert(isfield(app.Controls, 'TabGroup'), 'Unsupported GUI: missing TabGroup.');
if nargin < 2 || isempty(registry)
    [n,d] = uigetfile('unified_registry.mat','Select your unified_registry.mat');
    if isequal(n,0), tab=[]; return; end
    loaded=load(fullfile(d,n),'registry'); registry=loaded.registry;
end
assert(isstruct(registry) && isscalar(registry) && ...
    isfield(registry,'Entries') && isfield(registry,'ProjectRoot'), ...
    'Select the unified registry, not a model file.');
root=char(registry.ProjectRoot);
expectedDB=fullfile(root,'database','engine_analysis.db');
assert(strcmpi(char(app.DT.DatabaseFile),expectedDB), ...
    'The GUI database must match the registry project database.');
assert(~isempty(registry.Entries),'Registry is empty.');
ids=[registry.Entries.Engine_ID];
assert(numel(unique(ids))==numel(ids),'Duplicate engine IDs in registry.');
% Select the exact tested add-on; no experimental bundle is moved into L5.
if nargin < 3 || isempty(predictorFile)
    [n,d]=uigetfile('PREDICT_UNIFIED_ENGINE.m', ...
        'Select PREDICT_UNIFIED_ENGINE.m from your working unified-predictor folder');
    if isequal(n,0), tab=[]; return; end
    predictorFile=fullfile(d,n);
end
[~,predictorName,predictorExtension]=fileparts(predictorFile);
assert(strcmp([predictorName predictorExtension],'PREDICT_UNIFIED_ENGINE.m') && ...
    isfile(predictorFile),'Select the existing unified predictor file.');
existing=findall(app.Controls.TabGroup,'Type','uitab','Tag','ABACUSExperimentalML');
if ~isempty(existing)
    tab=existing(1); app.Controls.TabGroup.SelectedTab=tab; return
end
tab=uitab(app.Controls.TabGroup,'Title','Experimental ML', ...
    'Tag','ABACUSExperimentalML');
grid=uigridlayout(tab,[7,1]);
grid.RowHeight={58,38,82,38,62,'1x',42};
uilabel(grid,'Text', ...
    ['EXPERIMENTAL / ACADEMIC SIMULATOR APPROXIMATION. NOT MANUFACTURER-VALIDATED. ' ...
     'PW127G reference validation failed; AE 2100D3 discrepancy remains unresolved.'], ...
    'WordWrap','on','BackgroundColor',[1 .94 .8]);
names=cell(1,numel(ids));
for k=1:numel(ids)
    names{k}=sprintf('%d | %s',ids(k),char(registry.Entries(k).Engine));
end
engine=uidropdown(grid,'Items',names,'ItemsData',ids);
form=uigridlayout(grid,[2,3]); form.RowHeight={24,30};
uilabel(form,'Text','Geometric altitude (m)');
uilabel(form,'Text','Mach (-)');
uilabel(form,'Text','Throttle (0 to 1)');
altitude=uieditfield(form,'numeric','Limits',[0 Inf],'Value',3000);
mach=uieditfield(form,'numeric','Limits',[0 Inf],'Value',.4);
throttle=uieditfield(form,'numeric','Limits',[0 1],'Value',.8);
button=uibutton(grid,'Text','Predict with selected experimental model', ...
    'ButtonPushedFcn',@predictNow);
status=uilabel(grid,'WordWrap','on','Text', ...
    'No query yet. Bounds and current simulator fingerprint are checked on every query.');
output=uitable(grid);
exportButton=uibutton(grid,'Text','Export session query log (MAT)', ...
    'Enable','off','ButtonPushedFcn',@exportLog);
history=cell(0,1);
engine.ValueChangedFcn=@invalidate;
altitude.ValueChangedFcn=@invalidate;
mach.ValueChangedFcn=@invalidate;
throttle.ValueChangedFcn=@invalidate;
app.Controls.TabGroup.SelectedTab=tab;

    function invalidate(~,~)
        output.Data=table();
        status.Text='Inputs changed. Run a new prediction; earlier queries remain in the session log.';
    end

    function predictNow(~,~)
        output.Data=table(); button.Enable='off';
        finish=onCleanup(@() enableButton(button));  
        X=[altitude.Value,mach.Value,throttle.Value];
        id=engine.Value;
        record=struct('TimestampUTC',string(datetime('now','TimeZone','UTC')), ...
            'Engine_ID',id,'Inputs',X,'Result',table(),'Error',"", ...
            'Operational',false,'PredictorFile',predictorFile);
        status.Text='Checking saved model, input bounds and simulator validity...'; drawnow;
        try
            assert(strcmpi(char(app.DT.DatabaseFile),expectedDB), ...
                'GUI database changed. Reopen the application with the registry database.');
            entry=registry.Entries([registry.Entries.Engine_ID]==id);
            b=load(char(entry.ModelFile),'bundle');
            assert(strcmpi(char(b.bundle.ProjectRoot),root), ...
                'Selected model belongs to a different project.');
            assert(~b.bundle.Operational,'Expected an experimental model.');
            mode=string(b.bundle.Mode);
            if mode=="EXPERIMENTAL_J79_CHEB" || mode=="EXPERIMENTAL_BOUNDARY_REVISION"
                assert(isfield(b.bundle,'Status') && ...
                    strcmp(b.bundle.Status,'MEETS_TESTED_SIMULATOR_CRITERIA'), ...
                    'Revised model still needs simulator-test review.');
            end
            % Resolve the selected predictor with cleanup before restoring path.
            result=invokePredictor(registry,id,X,predictorFile);
            record.Result=result;
            output.Data=result;
            output.ColumnName=result.Properties.VariableNames;
            if all(result.PredictionAvailable)
                status.Text=['EXPERIMENTAL prediction available. Not real-engine validation. ' ...
                    'The predictor also executes a physics validity check; this is not a raw-ML latency benchmark.'];
            else
                status.Text='Prediction unavailable: '+strjoin(string(result.Note),' | ')+ ...
                    '. No automatic substitution was made.';
            end
        catch ex
            record.Error=string(getReport(ex,'extended','hyperlinks','off'));
            status.Text="Prediction blocked: "+string(ex.message);
            uialert(app.UIFigure,ex.message,'Experimental prediction unavailable');
        end
        history{end+1,1}=record;
        exportButton.Enable='on';
    end

    function enableButton(buttonHandle)
        if isvalid(buttonHandle)
            buttonHandle.Enable = 'on';
        end
    end

    function exportLog(~,~)
        [n,d]=uiputfile('*.mat','Save experimental session log','experimental_gui_log.mat');
        if isequal(n,0), return; end
        sessionLog=history; 
        label='Experimental simulator approximation; not manufacturer validation.'; 
        try
            save(fullfile(d,n),'sessionLog','registry','label');
            status.Text='Experimental session log saved. Existing project database and models are unchanged.';
        catch ex
            uialert(app.UIFigure,ex.message,'Export failed');
        end
    end
end

function result=invokePredictor(registry,id,X,predictorFile)
oldPath=path; cleanup=onCleanup(@() path(oldPath)); 
addpath(fileparts(predictorFile),'-begin');
resolved=which('PREDICT_UNIFIED_ENGINE');
assert(strcmpi(resolved,predictorFile), ...
    'Another predictor shadows the selected file. Change Current Folder to this GUI add-on folder.');
result=PREDICT_UNIFIED_ENGINE(registry,id,X);
end
