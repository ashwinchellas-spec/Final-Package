function r = gas_turbine_cycle(e,f)
%GAS_TURBINE_CYCLE Authoritative shared TJ/TF/TP steady-state thermodynamic kernel.
% Inputs: e from db_get_engine; f from flight_condition. Output: standard SI result.
% Ref: ABACUS 17; departures and off-design assumptions are in CHANGELOG/ASSUMPTIONS.
% Rated thrust/power never scales predictions; efficiencies never fit reference data.
r = result_template(e,f); r.Warnings = validate_inputs(e,f);
p = e.Params; c = project_config(); a = ISA_model(f.GeopotentialAltitude_m,f.Mach,'geopotential');
if f.Throttle==0
    r.Valid = true; r.Status = 'WARNING'; r.FuelFlow_kgs = 0;
    r.EquivalentThrust_N = 0; r.Thrust_N = 0; r.ShaftPower_kW = 0;
    r.Warnings(end+1) = "Engine-off convention: zero net output; windmilling drag is outside scope.";
    return
end
isFan = contains(e.Type,'Turbofan'); isProp = strcmp(e.Type,'Turboprop');
ram = 1;
if f.Mach>1, ram = 1-.075*(f.Mach-1)^1.35; end
T2 = a.Tt_K; P2 = a.Pt_Pa*p.Inlet_PR_recovery*ram;
% Fixed corrected-flow approximation, independently documented, not a compressor map.
flowFactor = .35+.65*f.Throttle;
mdot = p.MassFlow_kgs*(P2/(c.P0_Pa*p.Inlet_PR_recovery))/sqrt(T2/c.T0_K)*flowFactor;
opr = 1+(p.OPR-1)*f.Throttle; alpha = 0;
fan = struct('Tt_K',T2,'Pt_Pa',P2,'Work_Jkg',0);
if isFan
    alpha = p.BPR; fanPR = 1+(p.Fan_PR-1)*f.Throttle;
    fan = compress_stage(T2,P2,fanPR,p.Eta_fan,c.cp_air,c.gamma_air);
    corePR = opr/fanPR;
else
    corePR = opr;
end
mc = mdot/(1+alpha); mb = mdot-mc;
comp = compress_stage(fan.Tt_K,fan.Pt_Pa,corePR,p.Eta_compressor,c.cp_air,c.gamma_air);
T4 = comp.Tt_K+f.Throttle*(p.T_t4_K-comp.Tt_K);
burn = burner_stage(comp.Tt_K,comp.Pt_Pa,T4,p.Eta_combustor,p.Burner_PR_loss,c.cp_air,c.cp_gas,c.FuelLHV_Jkg);
far = burn.FuelAirRatio; mg = mc*(1+far); fuel = mc*far;
% Fan Work_Jkg already contains cp: do not multiply it by cp a second time.
demand = comp.Work_Jkg+(1+alpha)*fan.Work_Jkg;
turb = turbine_stage(T4,burn.Pt_Pa,demand,far,p.Eta_mechanical,p.Eta_turbine,c.cp_gas,c.gamma_gas);
nozzleT = turb.Tt_K; nozzleP = turb.Pt_Pa;
prop = struct('Thrust_N',0); shaft = 0; p7 = NaN; t7 = NaN;
if isProp
    p7 = a.P_Pa*p.PowerTurbine_BackPressure_Ratio;
    if p7>=turb.Pt_Pa, error('ABACUS:PowerTurbine','No pressure head remains for the power turbine.'); end
    t7 = turb.Tt_K*(1-p.Eta_power_turbine*(1-(p7/turb.Pt_Pa)^((c.gamma_gas-1)/c.gamma_gas)));
    shaft = mg*c.cp_gas*(turb.Tt_K-t7)*p.Eta_mechanical;
    propPower = shaft*p.Eta_gearbox;
    prop = propeller_model(propPower,p.Eta_propeller,a.Density_kgm3,p.Prop_Diameter_m,a.Velocity_ms,a.SoundSpeed_ms,p.Prop_RPM);
    nozzleT = t7; nozzleP = p7;
    r.ShaftPower_kW = propPower/1000; r.PropShaftPower_kW = propPower/1000;
    r.BSFC_kgkWh = fuel*3600/r.ShaftPower_kW;
end
core = nozzle_model(nozzleT,nozzleP,a.P_Pa,mg,c.gamma_gas,c.R_gas,p.Eta_nozzle_core);
coreForce = core.GrossThrust_N-mc*a.Velocity_ms;
bypassForce = 0; bypassEnergy = 0;
if isFan && mb>0
    bypass = nozzle_model(fan.Tt_K,fan.Pt_Pa,a.P_Pa,mb,c.gamma_air,c.R_air,p.Eta_nozzle_bypass);
    bypassForce = bypass.GrossThrust_N-mb*a.Velocity_ms;
    bypassEnergy = .5*mb*(bypass.ExpandedVelocity_ms^2-a.Velocity_ms^2);
    r.Bypass_Nozzle_State = bypass.State;
end
net = coreForce+bypassForce+prop.Thrust_N;
if net<=0 || ~isfinite(net), error('ABACUS:NonpositiveNetThrust','No positive propulsive output at this operating point.'); end
jetEnergy = .5*(mg*core.ExpandedVelocity_ms^2-mc*a.Velocity_ms^2)+bypassEnergy;
if isProp
    convertedPower = jetEnergy+propPower;
    r.Thrust_N = NaN;
    r.ESHP = (propPower+coreForce*a.Velocity_ms/p.Eta_propeller)/745.6998715822702;
else
    convertedPower = jetEnergy;
    r.Thrust_N = net; r.TSFC_kgNs = fuel/net;
end
r.EquivalentThrust_N = net; r.FuelFlow_kgs = fuel;
r.Eta_thermal = convertedPower/(fuel*c.FuelLHV_Jkg);
r.Eta_propulsive = net*a.Velocity_ms/convertedPower;
r.Eta_overall = net*a.Velocity_ms/(fuel*c.FuelLHV_Jkg);
r.T_t4_K = T4; r.P_t3_Pa = comp.Pt_Pa; r.Core_Nozzle_State = core.State;
ids = [0;2;2.5;3;4;5]; temps = [a.Tt_K;T2;fan.Tt_K;comp.Tt_K;T4;turb.Tt_K];
pressures = [a.Pt_Pa;P2;fan.Pt_Pa;comp.Pt_Pa;burn.Pt_Pa;turb.Pt_Pa];
flows = [mdot;mdot;mdot;mc;mg;mg];
if ~isFan, ids(3)=[]; temps(3)=[]; pressures(3)=[]; flows(3)=[]; end
if isProp, ids(end+1)=7; temps(end+1)=t7; pressures(end+1)=p7; flows(end+1)=mg; end
r.Stations = table(ids,temps,pressures,flows,'VariableNames',{'Station','Tt_K','Pt_Pa','MassFlow_kgs'});
r.Stations = [r.Stations;table(8,core.Tt_K,core.Pt_Pa,mg,'VariableNames',r.Stations.Properties.VariableNames)];
if isFan && mb>0
    r.Stations = [r.Stations;table(18,bypass.Tt_K,bypass.Pt_Pa,mb,'VariableNames',r.Stations.Properties.VariableNames)];
end
r.Diagnostics = struct('CoreNozzle',core,'CompressorWork_Jkg',comp.Work_Jkg,...
    'FanWork_Jkg',fan.Work_Jkg,'CoreFlow_kgs',mc,'BypassFlow_kgs',mb,...
    'GasFlow_kgs',mg,'AirFlow_kgs',mdot,'FuelAirRatio',far,'Propeller',prop,...
    'MassResidual_kgs',mg+mb-mdot-fuel,'BurnerResidual_W',mc*burn.EnergyResidual_Jkg,...
    'ShaftResidual_W',mc*turb.WorkResidual_Jkg,'GasGeneratorPower_W',shaft,...
    'CoreThrust_N',coreForce,'BypassThrust_N',bypassForce,'JetEnergyRate_W',jetEnergy,...
    'Model_OPR',opr,'InletRecovery',ram*p.Inlet_PR_recovery);
if isFan && mb>0, r.Diagnostics.BypassNozzle = bypass; end
if far>.07, r.Warnings(end+1) = "Fuel-air ratio exceeds 0.07; near the academic model limit."; end
r = validate_outputs(r);
end
