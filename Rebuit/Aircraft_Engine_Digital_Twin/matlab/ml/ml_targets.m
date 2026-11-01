function names = ml_targets(engineType)
%ML_TARGETS Architecture-specific output schema; no cross-architecture regressor.
% Input: architecture string. Output: cell array of SI result fields. Ref: ABACUS 20.2.
switch char(engineType)
    case 'Turbojet', names={'Thrust_N','TSFC_kgNs','Eta_thermal','Eta_propulsive'};
    case {'Turbofan_HighBPR','Turbofan_LowBPR'}, names={'Thrust_N','TSFC_kgNs','Eta_thermal'};
    case 'Turboprop', names={'EquivalentThrust_N','BSFC_kgkWh','ShaftPower_kW','ESHP','Eta_thermal','Eta_propulsive'};
    case 'Piston', names={'EquivalentThrust_N','BSFC_kgkWh','ShaftPower_kW','Eta_thermal','Eta_propulsive'};
    otherwise, error('ABACUS:MLArchitecture','No ML output contract for this architecture.');
end
end
