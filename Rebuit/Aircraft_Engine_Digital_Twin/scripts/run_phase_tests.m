function results = run_phase_tests(phase)
%RUN_PHASE_TESTS Run the existing relevant tests for one numbered implementation phase.
% Input: phase integer 1-15. Output: actual results; does not assert phase completion.
p=project_paths(); addpath(p.root,genpath(p.matlab),p.gui,p.simulink,p.tests);
validateattributes(phase,{'numeric'},{'scalar','integer','>=',1,'<=',15});
mapping={'TestDatabase.m','TestAtmosphere.m','TestEngines.m','TestEngines.m',...
    'TestEngines.m','TestEngines.m','TestEngines.m','TestIntegration.m','TestIntegration.m',...
    'TestIntegration.m','TestMission.m','TestML.m','TestML.m','TestGUI.m','TestSimulink.m'};
suite=matlab.unittest.TestSuite.fromFile(fullfile(p.tests,mapping{phase}));
runner=matlab.unittest.TestRunner.withTextOutput; results=runner.run(suite);
end
