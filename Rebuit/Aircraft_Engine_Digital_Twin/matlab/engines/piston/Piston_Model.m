function r = Piston_Model(e,f)
%PISTON_MODEL Optional naturally aspirated four/two-stroke brake-power model.
% Inputs: provenance-bearing engine e, standard flight f. Output: SI performance.
% Airflow = rho*displacement*RPM/(30*strokes)*volumetric_efficiency*throttle.
% Brake efficiency is explicit; Otto efficiency is an upper-bound check, not a fit.
% Ref: user phase 3; this architecture is outside ABACUS's 11-engine core.
if ~strcmp(e.Type,'Piston'), error('ABACUS:Architecture','Piston_Model requires a piston engine.'); end
r = result_template(e,f); r.Warnings = validate_inputs(e,f); p = e.Params;
a = ISA_model(f.GeopotentialAltitude_m,f.Mach,'geopotential');
if f.Throttle==0
    r.Valid=true; r.Status='WARNING'; r.FuelFlow_kgs=0; r.ShaftPower_kW=0; r.EquivalentThrust_N=0;
    r.Warnings(end+1)="Engine-off convention; windmilling is excluded."; return
end
c = project_config(); idealOtto = 1-p.Compression_Ratio^(1-c.gamma_air);
if p.Brake_Thermal_Efficiency>=idealOtto
    error('ABACUS:PistonEfficiency','Brake efficiency must be below the ideal Otto cycle limit.');
end
rpm = p.Rated_RPM; air = a.Density_kgm3*p.Displacement_m3*rpm/(30*p.Strokes)*p.Volumetric_Efficiency*f.Throttle;
fuel = air/p.AFR; power = fuel*p.Fuel_LHV_Jkg*p.Brake_Thermal_Efficiency;
prop = propeller_model(power,p.Eta_propeller,a.Density_kgm3,p.Prop_Diameter_m,a.Velocity_ms,a.SoundSpeed_ms,rpm);
r.ShaftPower_kW=power/1000; r.PropShaftPower_kW=power/1000; r.FuelFlow_kgs=fuel;
r.BSFC_kgkWh=fuel*3600/r.ShaftPower_kW; r.EquivalentThrust_N=prop.Thrust_N;
r.Eta_thermal=p.Brake_Thermal_Efficiency; r.Eta_propulsive=prop.UsefulPower_W/power;
r.Eta_overall=prop.UsefulPower_W/(fuel*p.Fuel_LHV_Jkg);
r.Diagnostics=struct('RPM',rpm,'Torque_Nm',power/(rpm*2*pi/60),'AirFlow_kgs',air,...
    'IdealOttoEfficiency',idealOtto,'Propeller',prop,'MassResidual_kgs',0,...
    'BurnerResidual_W',0,'ShaftResidual_W',0);
r.Warnings(end+1)="Optional piston extension: manifold pressure, detailed heat transfer and supercharging are not modelled.";
r = validate_outputs(r);
end
