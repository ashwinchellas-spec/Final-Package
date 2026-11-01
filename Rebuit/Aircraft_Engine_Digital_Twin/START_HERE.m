function output = START_HERE(action)
%START_HERE Run this file from the MATLAB Editor to analyse engine altitude performance.
% START_HERE('gui') opens the existing interactive application.
% START_HERE('check') checks installation; START_HERE('tests') runs the tests.
% Output: actual result struct/table, or an app object. No precomputed claims.
if nargin < 1, action = 'altitude'; end
action = validatestring(action, {'altitude','gui','check','tests','catalogue'});
root = fileparts(mfilename('fullpath'));
cd(root);
addpath(root, '-begin');
required = {'project_paths.m','setup_project.m', ...
    fullfile('matlab','setup','db_execute_script.m'), ...
    fullfile('matlab','setup','DB_Interface.m'), ...
    fullfile('database','schema.sql'),fullfile('database','seed_data.sql')};
for i = 1:numel(required)
    if ~isfile(fullfile(root,required{i}))
        error('ABACUS:IncompleteExtraction', ...
            'Missing %s. Extract the entire rebuilt ZIP into a NEW folder.',required{i});
    end
end
addpath(genpath(fullfile(root,'matlab')),fullfile(root,'gui'), ...
    fullfile(root,'simulink'),fullfile(root,'scripts'),'-begin');
rehash;
expected = fullfile(root,'matlab','setup','db_execute_script.m');
if ~strcmpi(which('db_execute_script'),expected)
    error('ABACUS:PathConflict', ...
        'MATLAB is using %s instead of %s. Restart MATLAB and open this START_HERE.m.', ...
        which('db_execute_script'),expected);
end
if verLessThan('matlab','23.2')
    error('ABACUS:Version','This package requires MATLAB R2023b or newer.');
end
if isempty(which('sqlite'))
    error('ABACUS:Dependency','Install MathWorks Database Toolbox, restart MATLAB, then run START_HERE.');
end
if ~usejava('jvm')
    error('ABACUS:Java','The project fingerprint requires Java. Start MATLAB with JVM support.');
end
p = setup_project();
db_seed_piston_extension(p.database_file);
fprintf('\nABACUS project: %s\nDatabase: %s\n',root,p.database_file);
switch action
    case 'altitude'
        output = run_altitude_study();
    case 'gui'
        output = EngineAnalyser_v1(p.database_file);
        if nargout == 0, assignin('base','abacusApp',output); end
    case 'check'
        output = verify_project(p.database_file);
    case 'tests'
        output = run_all_tests();
    case 'catalogue'
        output = export_engine_database(p.database_file);
        disp(output.Catalogue);
end
end
