function mode = db_sql_mode()
%DB_SQL_MODE Choose an atomic driver path using disposable native SQLite tests.
% Cached per MATLAB session. Candidate failure never touches the project DB.
% There is no fallback to committing individual script statements.
persistent accepted
if ~isempty(accepted), mode = accepted; return; end
candidates = {'execute','fetch'}; reasons = cell(size(candidates));
for i = 1:numel(candidates)
    try
        probe(candidates{i});
        accepted = candidates{i}; mode = accepted; return
    catch exception
        reasons{i} = sprintf('%s:\n%s',candidates{i},getReport(exception,'extended','hyperlinks','off'));
    end
end
error('ABACUS:SQLiteDriver', ...
    'No atomic SQL script method passed the temporary database checks.\n%s', ...
    strjoin(reasons,newline));
end
function probe(mode)
file = [tempname,'.db'];
connection = sqlite(file,'create'); cleanup = onCleanup(@() close_delete(connection,file));
execute(connection,'CREATE TABLE Probe (ID INTEGER PRIMARY KEY, Value TEXT)');
connection.AutoCommit = 'off';
db_sql_transport(connection,'BEGIN IMMEDIATE TRANSACTION',mode);
db_sql_transport(connection,'INSERT INTO Probe VALUES(1,''committed'')',mode);
commit(connection);
assert(count_rows(connection)==1,'Transaction commit was not visible.');
db_sql_transport(connection,'BEGIN IMMEDIATE TRANSACTION',mode);
db_sql_transport(connection,'INSERT INTO Probe VALUES(2,''must roll back'')',mode);
rollback(connection);
assert(count_rows(connection)==1,'Rollback did not undo the inserted row.');
% Confirm rollback remains possible after a statement failure.
db_sql_transport(connection,'BEGIN IMMEDIATE TRANSACTION',mode);
db_sql_transport(connection,'INSERT INTO Probe VALUES(3,''must also roll back'')',mode);
failed = false;
try
    db_sql_transport(connection,'INSERT INTO MissingProbeTable VALUES(1)',mode);
catch
    failed = true;
end
assert(failed,'Intentional statement failure did not propagate.');
rollback(connection);
assert(count_rows(connection)==1,'Failed-script rollback did not preserve atomicity.');
% DDL must roll back too: schema initialization uses the same path.
db_sql_transport(connection,'BEGIN IMMEDIATE TRANSACTION',mode);
db_sql_transport(connection,'CREATE TABLE RolledBackDDL (ID INTEGER)',mode);
rollback(connection);
t = fetch(connection,'SELECT count(*) AS n FROM sqlite_master WHERE name=''RolledBackDDL''');
assert(double(t{1,1})==0,'Schema changes did not roll back.');
db_sql_transport(connection,'BEGIN IMMEDIATE TRANSACTION',mode);
commit(connection);
connection.AutoCommit = 'on';
end
function n = count_rows(connection)
t = fetch(connection,'SELECT count(*) AS n FROM Probe'); n = double(t{1,1});
end
function close_delete(connection,file)
try, close(connection); catch, end
for suffix = {'','-wal','-shm','-journal'}
    path = [file,suffix{1}]; if isfile(path), delete(path); end
end
end
