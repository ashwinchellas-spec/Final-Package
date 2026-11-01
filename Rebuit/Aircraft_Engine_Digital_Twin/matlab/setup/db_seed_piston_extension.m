function db_seed_piston_extension(databaseFile)
%DB_SEED_PISTON_EXTENSION Add two optional piston catalogue entries with assumed data.
% Input: optional DB path. Output: 13-engine catalogue when explicitly requested.
% Outside ABACUS core scope; every added parameter is Assumed/Low and unverified.
p=project_paths(); if nargin<1, databaseFile=p.database_file; end
db=DB_Interface(databaseFile); cleanup=onCleanup(@() delete(db));
db_execute_script(db.Connection,fullfile(p.database,'seed_piston_extension.sql'));
end
