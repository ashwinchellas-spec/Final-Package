function t = format_result_metrics(r,units)
%FORMAT_RESULT_METRICS Convert display values only; saved/backend data remain SI.
% Input: standard result and SI/Imperial. Output: Quantity/Value/Unit table.
% Ref: ABACUS 22.3; exact international pound/foot conversions where relevant.
if nargin<2, units='SI'; end
keys={'Thrust_N','EquivalentThrust_N','ShaftPower_kW','FuelFlow_kgs','TSFC_kgNs','BSFC_kgkWh','Eta_thermal','Eta_propulsive','Eta_overall'};
si={'kN','kN','kW','kg/s','kg/(kN h)','kg/(kW h)','1','1','1'};
factor=[.001,.001,1,1,3.6e6,1,1,1,1];
if strcmp(units,'Imperial')
    si={'lbf','lbf','hp','lb/s','lb/(lbf h)','lb/(hp h)','1','1','1'};
    factor=[1/4.4482216152605,1/4.4482216152605,1000/745.6998715822702,...
        1/.45359237,3600*4.4482216152605/.45359237,...
        .7456998715822702/.45359237,1,1,1];
end
values=zeros(numel(keys),1);
for i=1:numel(keys), values(i)=r.(keys{i})*factor(i); end
keep=isfinite(values); t=table(string(keys(keep))',values(keep),string(si(keep))',...
    'VariableNames',{'Quantity','Value','Unit'});
end
