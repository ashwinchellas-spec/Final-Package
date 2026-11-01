function p = project_paths()
%PROJECT_PATHS Resolve portable project locations from this file.
% Inputs: none. Outputs: p structure of absolute paths. Units: filesystem paths.
% Assumption: this function stays in the extracted project root. No I/O mutations.
p.root = fileparts(mfilename('fullpath'));
for name = ["database","matlab","tests","gui","simulink","results","plots","tables","reports","ml_models","docs"]
    p.(name) = fullfile(p.root,name);
end
p.database_file = fullfile(p.database,'engine_analysis.db');
p.test_database_file = fullfile(p.database,'engine_test.db');
end
