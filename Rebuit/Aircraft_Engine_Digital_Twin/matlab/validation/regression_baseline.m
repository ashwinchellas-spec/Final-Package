function report = regression_baseline(action,databaseFile)
%REGRESSION_BASELINE Capture/compare real executed model outputs with a 0.01% threshold.
% Input: capture or compare; optional DB path. Output: comparison table and MAT evidence.
% Capturing requires passing internal physics tests. A baseline is not a measured reference.
p=project_paths(); if nargin<2, databaseFile=p.database_file; end
validatestring(action,{'capture','compare'}); file=fullfile(p.reports,'regression_baseline.mat');
dt=DT_Coordinator(databaseFile); cleanup=onCleanup(@() delete(dt)); cat=dt.Database.read('Engines');
rows=cell(height(cat),1);
for i=1:height(cat), rows{i}=result_row(dt.run(cat.Engine_ID(i),flight_condition(0,0,1),'L1',false)); end
current=vertcat(rows{:});
if strcmp(action,'capture')
    if isfile(file), error('ABACUS:ExistingBaseline','Archive the existing baseline before capturing a replacement.'); end
    checked=validate_physics(databaseFile);
    if ~all([checked.InternalTests.Passed]), error('ABACUS:BaselineGate','Internal physics tests must pass before baseline capture.'); end
    baseline=current; capturedUTC=utc_timestamp(); %#ok<NASGU>
    save(file,'baseline','capturedUTC'); report=current;
else
    if ~isfile(file), error('ABACUS:MissingBaseline','Capture a baseline after running internal physics tests.'); end
    data=load(file,'baseline'); baseline=data.baseline;
    if ~isequal(baseline.Engine_ID,current.Engine_ID), error('ABACUS:BaselineCatalogue','Catalogue IDs changed; review baseline applicability.'); end
    metrics={'EquivalentThrust_N','FuelFlow_kgs','ShaftPower_kW','T_t4_K','P_t3_Pa'};
    report=table(current.Engine_ID,string(current.Engine),'VariableNames',{'Engine_ID','Engine'});
    maximum=zeros(height(current),1);
    for j=1:numel(metrics)
        old=baseline.(metrics{j}); new=current.(metrics{j});
        difference=abs(new-old)./max(abs(old),1e-12); difference(isnan(old)&isnan(new))=0;
        difference(~isfinite(difference))=Inf; maximum=max(maximum,difference);
    end
    report.MaximumRelativeChange=maximum; report.Pass=maximum<=1e-4 & baseline.Valid==current.Valid;
    writetable(report,fullfile(p.reports,'regression_comparison.csv'));
end
end
