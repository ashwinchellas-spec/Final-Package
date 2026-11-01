function p = setup_project(databaseFile)
%SETUP_PROJECT Add authoritative source folders and initialise an absent database.
% Input: optional SQLite path. Output: path structure p. Units: paths.
% Requires MATLAB R2023b and Database Toolbox; throws actionable dependency errors.
p = project_paths();
if nargin < 1, databaseFile = p.database_file; end
if verLessThan('matlab','23.2'), error('ABACUS:Version','MATLAB R2023b or newer is required.'); end
addpath(p.root,genpath(p.matlab),p.gui,p.simulink,fullfile(p.root,'scripts'));
if exist('sqlite','file') == 0
    error('ABACUS:Dependency','Install Database Toolbox to use the native SQLite interface.');
end
for name = ["results","plots","tables","reports","ml_models"]
    if ~isfolder(p.(name)), mkdir(p.(name)); end
end
db_initialize(databaseFile);
db_seed(databaseFile);
p.database_file = databaseFile;
end
