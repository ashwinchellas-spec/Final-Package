function warnings = validate_inputs(e,f)
%VALIDATE_INPUTS Enforce engine envelopes and component parameter bounds.
% Inputs: engine and standard flight structs. Output: warning string column.
% Units: SI. Ref: ABACUS 18, with exact engine limits from Table 18.5.
% Throws ABACUS error identifiers on hard failures; low-throttle use is warned.
p = e.Params; warnings = strings(0,1);
required = {'MaxAltitude_m','MaxMach','DryWeight_kg'};
if strcmp(e.Type,'Piston')
    required = [required,{'Displacement_m3','Compression_Ratio','Rated_RPM','Strokes',...
        'Volumetric_Efficiency','Brake_Thermal_Efficiency','Fuel_LHV_Jkg','AFR'}];
else
    required = [required,{'OPR','T_t4_K','MassFlow_kgs','Eta_compressor','Eta_combustor',...
        'Eta_turbine','Eta_mechanical','Eta_nozzle_core','Inlet_PR_recovery','Burner_PR_loss'}];
end
if contains(e.Type,'Turbofan'), required = [required,{'BPR','Fan_PR','Eta_fan','Eta_nozzle_bypass'}]; end
if strcmp(e.Type,'Turboprop')
    required = [required,{'Eta_gearbox','Eta_propeller','Eta_power_turbine','Prop_Diameter_m',...
        'Prop_RPM','PowerTurbine_BackPressure_Ratio'}];
end
for i = 1:numel(required)
    name = required{i};
    if ~isfield(p,name) || ~isnumeric(p.(name)) || ~isscalar(p.(name)) || ~isfinite(p.(name)) || ~isreal(p.(name))
        error('ABACUS:MissingParameter','Missing or nonfinite parameter %s for %s.',name,e.Name);
    end
end
if f.GeopotentialAltitude_m<0 || f.GeopotentialAltitude_m>min(32000,p.MaxAltitude_m)+1e-8
    error('ABACUS:ERR_ATM_01','H=%.1f m exceeds the engine envelope 0 to %.1f m.',f.GeopotentialAltitude_m,p.MaxAltitude_m);
end
if ~isfinite(f.Mach) || f.Mach<0 || f.Mach>p.MaxMach
    error('ABACUS:ERR_MACH_01','Mach %.3g exceeds the %s range 0 to %.3g.',f.Mach,e.Name,p.MaxMach);
end
if ~isfinite(f.Throttle) || f.Throttle<0 || f.Throttle>1
    error('ABACUS:ERR_IN_01','Throttle must be between zero and one.');
end
if f.Afterburner, error('ABACUS:AfterburnerUnsupported','Afterburner-on calculations are outside ABACUS Phase 1.'); end
if strcmp(e.Type,'Piston')
    if p.Displacement_m3<=0 || p.Rated_RPM<=0 || p.AFR<=0 || p.Compression_Ratio<=1 || ~ismember(p.Strokes,[2,4])
        error('ABACUS:PistonParameter','Invalid displacement, RPM, AFR, compression ratio or stroke count.');
    end
else
    if p.OPR<=1 || p.OPR>50, error('ABACUS:ERR_IN_03','Overall pressure ratio must satisfy 1 < OPR <= 50.'); end
    if p.T_t4_K<400 || p.T_t4_K>2500, error('ABACUS:ERR_IN_02','Design TIT must be 400 to 2500 K.'); end
    if p.T_t4_K<800 || p.T_t4_K>1900, warnings(end+1) = "Design TIT is outside the usual academic range."; end
    if p.MassFlow_kgs<=0, error('ABACUS:ERR_FLOW_01','Corrected design flow must be positive.'); end
    if p.Burner_PR_loss<0 || p.Burner_PR_loss>.2 || p.Inlet_PR_recovery<=0 || p.Inlet_PR_recovery>1
        error('ABACUS:PressureLoss','Invalid burner loss or inlet recovery.');
    end
end
fields = fieldnames(p);
for i = 1:numel(fields)
    name = fields{i}; value = p.(name);
    if (startsWith(name,'Eta_') || endsWith(name,'Efficiency')) && isnumeric(value) && ~isnan(value)
        if ~isfinite(value) || value<=0 || value>1, error('ABACUS:Efficiency','%s must be in (0,1].',name); end
    end
end
bounds = {'Eta_compressor',.70,.92;'Eta_turbine',.85,.95;'Eta_fan',.80,.92;...
    'Eta_combustor',.95,1;'Eta_mechanical',.97,1;'Eta_gearbox',.96,1;'Eta_propeller',eps,.92};
for i = 1:size(bounds,1)
    key = bounds{i,1};
    if isfield(p,key) && ~isnan(p.(key)) && (p.(key)<bounds{i,2} || p.(key)>bounds{i,3})
        error('ABACUS:EfficiencyRange','%s is outside the ABACUS component range.',key);
    end
end
if contains(e.Type,'Turbofan') && (p.Fan_PR<=1 || p.Fan_PR>=p.OPR || p.BPR<0 || p.BPR>15)
    error('ABACUS:FanParameters','Require 1 < Fan_PR < OPR and 0 <= BPR <= 15.');
end
if strcmp(e.Type,'Turboprop') && (p.Prop_Diameter_m<=0 || p.Prop_RPM<=0 || p.PowerTurbine_BackPressure_Ratio<=1)
    error('ABACUS:PropellerParameters','Positive propeller geometry/speed and residual NPR > 1 are required.');
end
if f.Throttle>0 && f.Throttle<.5, warnings(end+1) = "Throttle below 0.5: uncalibrated academic off-design extrapolation."; end
if e.Estimated, warnings(end+1) = "Estimated/assumed cycle parameters; real engine accuracy has not been established."; end
if e.IsKaveri, config = project_config(); warnings(end+1) = string(config.KaveriWarning); end
end
