function db_initialize(filename)
%DB_INITIALIZE Reproduce schema in a new DB; preserve and verify existing files.
% Input: optional SQLite file path. Output: DB on disk. Ref: ABACUS 11 + schema.sql.
% Existing incompatible databases raise an error; no automatic destructive migration.
p = project_paths();
if nargin < 1, filename = p.database_file; end
if isfile(filename)
    db = DB_Interface(filename); clean = onCleanup(@() delete(db));
    t = db.pragma('user_version');
    if istable(t), version = t{1,1}; else, version = t{1}; end
    if version ~= 2, error('ABACUS:Schema','Expected schema version 2; back up and migrate this database.'); end
    return
end
folder = fileparts(filename);
if ~isempty(folder) && ~isfolder(folder), mkdir(folder); end
connection = sqlite(char(filename),'create');
clean = onCleanup(@() close(connection));
execute(connection,'PRAGMA foreign_keys = ON');
db_execute_script(connection,fullfile(p.database,'schema.sql'));
end
