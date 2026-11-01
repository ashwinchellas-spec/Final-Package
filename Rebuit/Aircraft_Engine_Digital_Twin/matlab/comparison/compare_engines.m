function t = compare_engines(dt,engineIDs,f,metric)
%COMPARE_ENGINES Same-condition performance table with explicit compatibility checks.
% Inputs: coordinator, engine IDs, flight condition, metric field. Output: ranked SI table.
% Ref: ABACUS 21-22. TSFC/BSFC and jet/shaft power cannot be ranked interchangeably.
if nargin<4, metric='EquivalentThrust_N'; end
allowed={'Thrust_N','EquivalentThrust_N','TSFC_kgNs','FuelFlow_kgs','ShaftPower_kW','BSFC_kgkWh'};
validatestring(metric,allowed); rows=cell(numel(engineIDs),1);
for i=1:numel(engineIDs), rows{i}=result_row(dt.run(engineIDs(i),f,'L1',false)); end
t=vertcat(rows{:});
if any(isnan(t.(metric)(logical(t.Valid))))
    error('ABACUS:IncompatibleMetric','%s is not defined for every selected architecture. Use equivalent thrust or select compatible engines.',metric);
end
ascending=ismember(metric,{'TSFC_kgNs','FuelFlow_kgs','BSFC_kgkWh'});
if ascending, direction='ascend'; else, direction='descend'; end
t=sortrows(t,metric,direction,'MissingPlacement','last');
t.ComparisonNote=repmat("Same operating condition; uninstalled academic outputs.",height(t),1);
end
