function t = utc_timestamp()
%UTC_TIMESTAMP Return an ISO 8601 UTC timestamp; no input and no physical units.
% Assumption: system clock is correct. Output is a char vector suitable for SQLite.
t = char(datetime('now','TimeZone','UTC','Format','yyyy-MM-dd''T''HH:mm:ss.SSS''Z'''));
end
