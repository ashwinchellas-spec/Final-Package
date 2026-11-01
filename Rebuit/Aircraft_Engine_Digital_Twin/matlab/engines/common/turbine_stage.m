function s = turbine_stage(Tin,Pin,work,f,etaM,etaT,cp,gamma)
%TURBINE_STAGE Balance compressor/fan shaft demand including fuel-added gas mass.
% Inputs: total K/Pa, demand J/kg core air, f, efficiencies, cp J/kg/K, gamma.
% Output: state and residual J/kg air. Ref: ABACUS 17.2.4; invalid expansion aborts.
Tout = Tin-work/(etaM*(1+f)*cp);
base = 1-(1-Tout/Tin)/etaT;
if Tout<=0 || Tout>=Tin || base<=0 || base>=1
    error('ABACUS:ERR_TURB_02','Turbine work demand cannot be supplied by the specified cycle.');
end
Pout = Pin*base^(gamma/(gamma-1));
s = struct('Tt_K',Tout,'Pt_Pa',Pout,...
    'WorkResidual_Jkg',etaM*(1+f)*cp*(Tin-Tout)-work);
end
