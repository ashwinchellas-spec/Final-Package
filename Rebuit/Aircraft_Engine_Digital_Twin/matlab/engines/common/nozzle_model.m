function n = nozzle_model(Tt,Pt,Pa,mdot,gamma,R,eta)
%NOZZLE_MODEL Adiabatic converging nozzle with sonic cap and pressure thrust.
% Inputs: total T [K], total/ambient P [Pa], gas flow [kg/s], gamma, R [J/kg/K], eta.
% Output: exit state, area [m2], momentum/pressure forces [N], critical NPR.
% eta is kinetic-energy efficiency; choking threshold follows the same energy law.
% Ref: ABACUS 17.2.5, NASA isentropic equations, CHANGELOG C05. No fixed geometry.
validateattributes([Tt,Pt,Pa,mdot,gamma,R,eta],{'numeric'},{'real','finite','vector'});
if min([Tt,Pt,Pa,mdot,R])<=0 || gamma<=1 || eta<=0 || eta>1
    error('ABACUS:ERR_NOZ_01','Nozzle needs positive state, flow, R, gamma>1 and 0<eta<=1.');
end
if Pt<=Pa, error('ABACUS:ERR_NOZ_02','Nozzle total pressure must exceed ambient pressure.'); end
cp = gamma*R/(gamma-1); exponent = (gamma-1)/gamma;
criticalBase = 1-(gamma-1)/((gamma+1)*eta);
if criticalBase<=0, error('ABACUS:NozzleEfficiency','Efficiency too small for the sonic nozzle formulation.'); end
critical = criticalBase^(-gamma/(gamma-1));
choked = Pt/Pa >= critical;
if choked, Pe = Pt/critical; else, Pe = Pa; end
Te = Tt*(1-eta*(1-(Pe/Pt)^exponent));
Ve = sqrt(2*cp*(Tt-Te)); Me = Ve/sqrt(gamma*R*Te);
rho = Pe/(R*Te); Ae = mdot/(rho*Ve);
pressureForce = (Pe-Pa)*Ae;
% Remaining ideal expansion energy provides an explicit pressure-energy convention.
expandedVelocity = sqrt(Ve^2+2*cp*Te*(1-(Pa/Pe)^exponent));
if choked, state = 'CHOKED'; else, state = 'UNCHOKED'; end
exitTotalPressure = Pe*(1+(gamma-1)/2*Me^2)^(gamma/(gamma-1));
n = struct('Tt_K',Tt,'Pt_Pa',exitTotalPressure,'Inlet_Pt_Pa',Pt,'T_K',Te,'P_Pa',Pe,'Velocity_ms',Ve,...
    'Mach',Me,'MassFlow_kgs',mdot,'Area_m2',Ae,'PressureThrust_N',pressureForce,...
    'GrossThrust_N',mdot*Ve+pressureForce,'ExpandedVelocity_ms',expandedVelocity,...
    'Choked',choked,'State',state,'NPR',Pt/Pa,'NPR_critical',critical,...
    'EnergyResidual_W',mdot*(cp*Tt-cp*Te-.5*Ve^2));
end
