function db_execute_script(connection, filename)
%DB_EXECUTE_SCRIPT Execute project SQL with manual-mode transaction control.
% Select a driver path proved atomic in a disposable database on this MATLAB.
% No auto-commit fallback: if transaction control fails the operation fails.
commands = regexp(fileread(filename), ...
    '(?m)^-- @statement[^\S\r\n]*\r?$', 'split');
transport = db_sql_mode();
if ~strcmpi(connection.AutoCommit,'on')
    error('ABACUS:NestedTransaction','SQL scripts require an idle AutoCommit-on connection.');
end
execute(connection,'PRAGMA foreign_keys = ON');
connection.AutoCommit = 'off';
begun = false; stage = 'starting a manual transaction';
try
    db_sql_transport(connection,'BEGIN IMMEDIATE TRANSACTION',transport);
    begun = true;
    for i = 1:numel(commands)
        command = strtrim(commands{i});
        if isempty(command) || strcmpi(command,'PRAGMA foreign_keys = ON;'), continue; end
        stage = sprintf('executing statement %d',i);
        db_sql_transport(connection,command,transport);
    end
    stage = 'committing the script';
    commit(connection);
    begun = false;
    connection.AutoCommit = 'on';
catch originalError
    if begun
        try
            rollback(connection);
        catch cleanupError
            originalError = addCause(originalError,cleanupError);
        end
    end
    try
        connection.AutoCommit = 'on';
    catch cleanupError
        originalError = addCause(originalError,cleanupError);
    end
    context = MException('ABACUS:SQLScript','Failed while %s in %s.',stage,char(filename));
    context = addCause(context,originalError);
    throw(context);
end
end
