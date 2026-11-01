function report = audit_dependencies()
%AUDIT_DEPENDENCIES Run MATLAB's dependency analyser and Code Analyzer on all sources.
% Input: none. Output: actual required files/products and diagnostics saved in reports.
% Dynamic GUI action strings/S-function names are also exercised by integration tests.
p=project_paths(); files=dir(fullfile(p.root,'**','*.m'));
paths=cell(numel(files),1); issues=cell(numel(files),1);
for i=1:numel(files)
    paths{i}=fullfile(files(i).folder,files(i).name); issues{i}=checkcode(paths{i},'-id');
end
[requiredFiles,products]=matlab.codetools.requiredFilesAndProducts(paths);
report=struct('Timestamp_UTC',utc_timestamp(),'Files',{requiredFiles},'Products',products,...
    'AnalysedSources',{paths},'CodeAnalyzer',{issues});
save(fullfile(p.reports,'matlab_dependency_audit.mat'),'report');
write_text(fullfile(p.reports,'matlab_dependency_audit.json'),jsonencode(report,'PrettyPrint',true));
end
