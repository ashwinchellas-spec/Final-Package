function db_sql_transport(connection, command, mode)
%DB_SQL_TRANSPORT Execute trusted SQL using a locally verified driver method.
switch mode
    case 'execute'
        execute(connection,command);
    case 'fetch'
        % MathWorks documents fetch SQL as any valid SQL statement.
        ignored = fetch(connection,command); %#ok<NASGU>
    otherwise
        error('ABACUS:SQLTransport','No verified SQL transport was selected.');
end
end
