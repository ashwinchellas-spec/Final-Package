function db_seed(filename)
%DB_SEED Insert stable catalogue IDs/provenance without overwriting existing rows.
% Input: optional DB path. Output: seeded DB. Units: schema-defined SI.
% Ref: database/seed_data.sql. Repeated calls are idempotent; SQL errors propagate.
p = project_paths();
if nargin < 1, filename = p.database_file; end
db = DB_Interface(filename); clean = onCleanup(@() delete(db));
db_execute_script(db.Connection,fullfile(p.database,'seed_data.sql'));
end
