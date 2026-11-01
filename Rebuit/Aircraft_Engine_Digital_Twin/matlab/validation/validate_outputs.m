function r = validate_outputs(r)
%VALIDATE_OUTPUTS Check active outputs, thermodynamics, mass and shaft conservation.
% Input/output: standard SI result struct. Ref: ABACUS 18. Inapplicable NaNs allowed.
% Hard conservation or nonfinite failures raise errors; confidence warnings remain.
active = [r.EquivalentThrust_N,r.FuelFlow_kgs,r.Eta_thermal,r.Eta_propulsive,r.Eta_overall];
if ismember(r.Architecture,{'Turboprop','Piston'})
    active = [active,r.ShaftPower_kW,r.BSFC_kgkWh];
else
    active = [active,r.Thrust_N,r.TSFC_kgNs];
end
if ~isreal(active) || any(~isfinite(active)) || any(active<0)
    error('ABACUS:ERR_NAN_01','An active output is negative, complex or nonfinite.');
end
if any([r.Eta_thermal,r.Eta_propulsive,r.Eta_overall]>1+1e-9)
    error('ABACUS:EfficiencyOutput','Computed efficiency exceeds unity; the operating point is rejected.');
end
if ~isempty(r.Stations)
    if any(r.Stations.Tt_K<=0 | r.Stations.Pt_Pa<=0 | r.Stations.MassFlow_kgs<=0)
        error('ABACUS:StationState','Station temperature, pressure and flow must be positive.');
    end
end
d = r.Diagnostics;
if isfield(d,'MassResidual_kgs') && abs(d.MassResidual_kgs)>1e-8*max(1,d.AirFlow_kgs)
    error('ABACUS:MassBalance','Mass conservation failed.');
end
for key = ["BurnerResidual_W","ShaftResidual_W"]
    if isfield(d,key) && abs(d.(key))>1e-6*max(1,r.FuelFlow_kgs*43.2e6)
        error('ABACUS:EnergyBalance','Energy balance failed at %s.',key);
    end
end
r.Valid = true;
if isempty(r.Warnings), r.Status = 'PASS'; else, r.Status = 'WARNING'; end
end
