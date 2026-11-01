function s = burner_stage(T3,P3,T4,eta,loss,cpAir,cpGas,LHV)
%BURNER_STAGE Fuel-air ratio from total-enthalpy conservation, including fuel mass.
% Inputs: K, Pa, K, efficiency, fractional pressure loss, cp J/kg/K, LHV J/kg.
% Output: f [-], total state, energy residual [J/kg air]. Ref: ABACUS 17.2.3.
if T4<=T3, error('ABACUS:ERR_COMB_01','Turbine inlet temperature must exceed compressor exit temperature.'); end
denominator = eta*LHV-cpGas*T4;
if denominator<=0, error('ABACUS:ERR_FAR_01','Combustor fuel energy denominator is not positive.'); end
f = (cpGas*T4-cpAir*T3)/denominator;
if f<=0 || f>=.1, error('ABACUS:ERR_FAR_02','Fuel-air ratio is outside (0,0.1).'); end
s = struct('Tt_K',T4,'Pt_Pa',P3*(1-loss),'FuelAirRatio',f,...
    'EnergyResidual_Jkg',cpAir*T3+f*eta*LHV-(1+f)*cpGas*T4);
end
