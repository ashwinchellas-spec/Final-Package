function output = export_engine_database(databaseFile, outputFolder)
%EXPORT_ENGINE_DATABASE Export catalogue, raw parameters and provenance to CSV.
% SQLite remains the authoritative database; CSV exports are inspection copies.
p = project_paths();
if nargin < 1, databaseFile = p.database_file; end
if nargin < 2, outputFolder = fullfile(p.database,'exports'); end
if ~isfolder(outputFolder), mkdir(outputFolder); end
db = DB_Interface(databaseFile); cleanup = onCleanup(@() delete(db));
catalogue = db.read('v_Engine_Catalogue');
writetable(catalogue,fullfile(outputFolder,'engine_catalogue.csv'));
names = {'Manufacturers','Engine_Types','Engine_Thermo_Params', ...
    'Parameter_Provenance','References'};
for i = 1:numel(names)
    writetable(db.read(names{i}),fullfile(outputFolder,[names{i},'.csv']));
end
output = struct('Catalogue',catalogue,'Folder',outputFolder);
fprintf('Database inspection CSVs: %s\n',outputFolder);
end
