function t = db_read_sqlite(connection, name)
%DB_READ_SQLITE Read nullable project data without driver NULL conversion.
% No database values are changed. Numeric NULL -> NaN; text NULL -> missing.
% Values and separate null masks are read as non-null TEXT, then decoded.
name = char(name);
if isempty(regexp(name,'^[A-Za-z][A-Za-z0-9_]*$','once'))
    error('ABACUS:SQLIdentifier','Invalid table/view identifier.');
end
meta = fetch(connection,sprintf([ ...
    'SELECT name, COALESCE(type,'''') AS declared_type ', ...
    'FROM pragma_table_info(''%s'') ORDER BY cid'],name));
if isempty(meta), error('ABACUS:SQLSchema','No columns found for %s.',name); end
names = string(meta{:,1}); types = upper(string(meta{:,2}));
count = numel(names); projections = cell(1,2*count);
numeric = false(count,1);
for i = 1:count
    column = ['"',strrep(char(names(i)),'"','""'),'"'];
    numeric(i) = any(contains(types(i),["INT","REAL","FLOA","DOUB","NUM","DEC","BOOL"]));
    projections{2*i-1} = sprintf('COALESCE(CAST(%s AS TEXT),'''') AS v%d',column,i);
    projections{2*i} = sprintf('CASE WHEN %s IS NULL THEN ''1'' ELSE ''0'' END AS n%d',column,i);
end
query = sprintf('SELECT %s FROM "%s"',strjoin(projections,','),name);
raw = fetch(connection,query);
t = table();
for i = 1:count
    if isempty(raw)
        values = strings(0,1); nulls = false(0,1);
    else
        values = string(raw{:,2*i-1}); values = values(:);
        nulls = string(raw{:,2*i})=="1"; nulls = nulls(:);
    end
    if numeric(i)
        decoded = str2double(values);
        if any(isnan(decoded) & ~nulls)
            error('ABACUS:SQLNumeric','Non-numeric value in %s.%s.',name,names(i));
        end
        decoded(nulls) = NaN;
    else
        decoded = values;
        % Empty TEXT and SQL NULL must remain distinct even if the driver
        % interprets an empty returned string as missing.
        decoded(~nulls & ismissing(decoded)) = "";
        decoded(nulls) = missing;
    end
    t.(char(names(i))) = decoded;
end
end
