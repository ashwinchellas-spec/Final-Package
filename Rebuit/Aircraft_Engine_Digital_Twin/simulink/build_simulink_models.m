function models = build_simulink_models(databaseFile,outputFolder,modelPrefix)
% Build three steady-state Simulink models using abacus_sfun.

p = project_paths();

if nargin < 1 || isempty(databaseFile)
    databaseFile = p.database_file;
end
if nargin < 2 || isempty(outputFolder)
    outputFolder = p.simulink;
end
if nargin < 3 || isempty(modelPrefix)
    modelPrefix = 'ABACUS';
end

modelPrefix = char(modelPrefix);

if ~isvarname(modelPrefix)
    error('ABACUS:ModelPrefix','Model prefix must be a valid MATLAB name.');
end

if ~license('test','Simulink')
    error('ABACUS:SimulinkRequired','Simulink is required.');
end

if ~isfolder(outputFolder)
    mkdir(outputFolder);
end

load_system('simulink');

models = {[modelPrefix '_Turbojet'], ...
    [modelPrefix '_Turbofan'], ...
    [modelPrefix '_Turboprop']};
ids = [1,4,9];

for i = 1:numel(models)
    model = models{i};

    if bdIsLoaded(model)
        error('ABACUS:ModelOpen', ...
            'Close %s before rebuilding to protect unsaved edits.',model);
    end

    new_system(model);
    cleanup = onCleanup(@() close_generated_model(model));

    workspace = get_param(model,'ModelWorkspace');
    assignin(workspace,'ABACUS_DATABASE',char(databaseFile));

    add_block('simulink/Sources/Constant', ...
        [model '/OperatingPoint'], ...
        'Value',sprintf('[%d;0;0;1]',ids(i)), ...
        'Position',[35,95,160,135]);

    add_block('simulink/User-Defined Functions/Level-2 MATLAB S-Function', ...
        [model '/SteadyStateEngine'], ...
        'FunctionName','abacus_sfun', ...
        'Parameters','ABACUS_DATABASE', ...
        'Position',[225,70,420,165]);

    add_block('simulink/Sinks/To Workspace', ...
        [model '/Result'], ...
        'VariableName','abacus_output', ...
        'SaveFormat','Array', ...
        'Position',[480,90,600,140]);

    add_line(model,'OperatingPoint/1','SteadyStateEngine/1');
    add_line(model,'SteadyStateEngine/1','Result/1');

    set_param(model, ...
        'SolverType','Fixed-step', ...
        'Solver','FixedStepDiscrete', ...
        'FixedStep','1', ...
        'StopTime','0', ...
        'ReturnWorkspaceOutputs','on');

    annotation = Simulink.Annotation(model, ...
        'Academic steady-state evaluation. No transient engine dynamics.');
    annotation.Position = [35,20];

    save_system(model,fullfile(outputFolder,[model '.slx']));
    clear cleanup
end
end

function close_generated_model(model)
if bdIsLoaded(model)
    close_system(model,0);
end
end
