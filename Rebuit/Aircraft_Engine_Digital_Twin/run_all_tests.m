function results = run_all_tests()
%RUN_ALL_TESTS Execute unit, integration, ML, GUI and Simulink tests in a safe test DB.
% Inputs: none. Output: actual matlab.unittest results and CSV evidence.
% Production DB is never used by fixtures. Unavailable optional capabilities are incomplete.
p=project_paths(); addpath(p.root,genpath(p.matlab),p.gui,p.simulink,p.tests);
suite=matlab.unittest.TestSuite.fromFolder(p.tests,'IncludingSubfolders',false);
runner=matlab.unittest.TestRunner.withTextOutput; results=runner.run(suite);
summary=table(string({results.Name})',[results.Passed]',[results.Failed]',[results.Incomplete]',[results.Duration]',...
    'VariableNames',{'Test','Passed','Failed','NotExecutedOrIncomplete','Duration_s'});
if ~isfolder(p.reports), mkdir(p.reports); end
writetable(summary,fullfile(p.reports,'matlab_test_results.csv'));
save(fullfile(p.reports,'matlab_test_results.mat'),'results');
fprintf('Passed: %d | Failed: %d | Incomplete: %d\n',nnz(summary.Passed),nnz(summary.Failed),nnz(summary.NotExecutedOrIncomplete));
end
