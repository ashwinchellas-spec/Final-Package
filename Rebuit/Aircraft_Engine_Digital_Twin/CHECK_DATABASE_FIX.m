function report = CHECK_DATABASE_FIX()
%CHECK_DATABASE_FIX Test native MATLAB/SQLite compatibility before startup.
% Transaction fixtures use a temporary DB. Project engine data are only read.
root = fileparts(mfilename('fullpath')); cd(root);
addpath(root,genpath(fullfile(root,'matlab')),'-begin'); rehash;
p = project_paths(); if ~isfolder(p.reports), mkdir(p.reports); end
logFile = fullfile(p.reports,'database_fix_diagnostic.txt');
folder = tempname; mkdir(folder); folderCleanup = onCleanup(@() remove_folder(folder));
try
    fprintf('1. Testing transaction commit, rollback and nullable reads in a temporary database...\n');
    test_driver(folder);
    fprintf('PASS: temporary database compatibility checks.\n');
    fprintf('2. Reading your existing engine catalogue and parameter provenance...\n');
    report = verify_project(p.database_file);
    failures = report.Status=="FAIL";
    if any(failures)
        error('ABACUS:Readiness','%s',strjoin(report.Diagnostic(failures),newline));
    end
    write_text(logFile,'PASS: native transaction and NULL-read tests plus existing project verification.');
    fprintf('\nDatabase checks passed. Next command: START_HERE\n');
catch exception
    text = getReport(exception,'extended','hyperlinks','off');
    write_text(logFile,text);
    fprintf('\nCHECK FAILED. Full diagnostic:\n%s\nSaved to: %s\n',text,logFile);
    rethrow(exception);
end
end
function test_driver(folder)
file = fullfile(folder,'driver_test.db');
connection = sqlite(file,'create'); cleanup = onCleanup(@() close(connection));
schema = fullfile(folder,'schema.sql');
write_text(schema,sprintf([ ...
    'CREATE TABLE NullableFixture (ID INTEGER, Amount REAL, Note TEXT);\n', ...
    '-- @statement\nINSERT INTO NullableFixture VALUES(1,NULL,NULL);\n', ...
    '-- @statement\nINSERT INTO NullableFixture VALUES(2,0,'''');\n', ...
    '-- @statement\nINSERT INTO NullableFixture VALUES(3,12.5,''Text'');\n']));
db_execute_script(connection,schema);
t = sortrows(db_read_sqlite(connection,'NullableFixture'),'ID');
assert(height(t)==3,'Fixture writes were not committed.');
assert(isnan(t.Amount(1)) && ismissing(t.Note(1)),'NULL decoding failed.');
assert(t.Amount(2)==0 && ~ismissing(t.Note(2)) && strlength(t.Note(2))==0,'Zero/empty text became missing.');
assert(t.Amount(3)==12.5 && t.Note(3)=="Text",'Non-null data changed.');
bad = fullfile(folder,'rollback.sql');
write_text(bad,sprintf([ ...
    'INSERT INTO NullableFixture VALUES(4,99,''must roll back'');\n', ...
    '-- @statement\nINSERT INTO MissingFixtureTable VALUES(1);\n']));
failed = false;
try
    db_execute_script(connection,bad);
catch exception
    failed = true;
    assert(contains(getReport(exception),'MissingFixtureTable'),'Original SQL error was lost.');
end
assert(failed,'Deliberate SQL error was not raised.');
assert(height(db_read_sqlite(connection,'NullableFixture'))==3,'Rollback failed: partial writes remain.');
empty = fullfile(folder,'empty.sql'); write_text(empty,'');
db_execute_script(connection,empty);
assert(strcmpi(connection.AutoCommit,'on'),'AutoCommit state was not restored.');
end
function remove_folder(folder)
if isfolder(folder), rmdir(folder,'s'); end
end
