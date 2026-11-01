function t = comparison_sweep(dt,engineIDs,axisName,values,f,metric)
%COMPARISON_SWEEP Compare altitude, Mach or throttle trends through the same backend.
% Inputs: DT, IDs, axis name, vector, baseline f, metric. Output: tidy comparison table.
% Units: H in geopotential m, Mach/throttle dimensionless; errors propagate.
validatestring(axisName,{'Altitude','Mach','Throttle'}); parts=cell(numel(values),1);
for i=1:numel(values)
    h=f.GeopotentialAltitude_m; m=f.Mach; theta=f.Throttle;
    switch axisName
        case 'Altitude', h=values(i);
        case 'Mach', m=values(i);
        case 'Throttle', theta=values(i);
    end
    parts{i}=compare_engines(dt,engineIDs,flight_condition(h,m,theta,'geopotential'),metric);
end
t=vertcat(parts{:});
end
