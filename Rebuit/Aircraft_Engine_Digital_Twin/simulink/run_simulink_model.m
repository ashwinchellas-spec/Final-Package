function output = run_simulink_model(modelName,operatingPoint,databaseFile)
%RUN_SIMULINK_MODEL Build if needed, set [ID,h,M,theta], and execute one equilibrium.
% Inputs: model name, 4-element numeric point, optional DB path. Output: SimulationOutput.
% No state integration or performance claims until this command actually runs.
p=project_paths(); if nargin<1, modelName='ABACUS_Turbojet'; end
if nargin<2, operatingPoint=[1;0;0;1]; end
if nargin<3, databaseFile=p.database_file; end
validatestring(modelName,{'ABACUS_Turbojet','ABACUS_Turbofan','ABACUS_Turboprop'});
validateattributes(operatingPoint,{'numeric'},{'vector','numel',4,'finite','real'});
file=fullfile(p.simulink,[modelName,'.slx']);
if ~isfile(file), build_simulink_models(databaseFile); end
load_system(file); cleanup=onCleanup(@() close_system(modelName,0));
input=Simulink.SimulationInput(modelName);
input=input.setVariable('ABACUS_DATABASE',char(databaseFile),'Workspace',modelName);
input=input.setBlockParameter([modelName,'/OperatingPoint'],'Value',mat2str(operatingPoint(:)));
output=sim(input);
end
