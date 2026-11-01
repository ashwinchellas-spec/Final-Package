function a = ISA_model(altitude_m, mach, convention)
%ISA_MODEL Three-layer ISA, with geometric/geopotential conversion and total state.
% Inputs: altitude [m], Mach [-], convention (default geometric). Output: SI struct.
% Ref: ABACUS 16; hydrostatic perfect gas. No extrapolation above H=32000 m.
if nargin < 2, mach = 0; end
if nargin < 3, convention = 'geometric'; end
f = flight_condition(altitude_m,mach,1,convention);
c = project_config(); H = f.GeopotentialAltitude_m;
P11 = c.P0_Pa*(216.65/c.T0_K)^(c.g0/(.0065*c.R_air));
P20 = P11*exp(-c.g0*9000/(c.R_air*216.65));
if H <= 11000
    T = c.T0_K-.0065*H;
    P = c.P0_Pa*(T/c.T0_K)^(c.g0/(.0065*c.R_air));
elseif H <= 20000
    T = 216.65; P = P11*exp(-c.g0*(H-11000)/(c.R_air*T));
else
    T = 216.65+.001*(H-20000);
    P = P20*(T/216.65)^(-c.g0/(.001*c.R_air));
end
rho = P/(c.R_air*T); sound = sqrt(c.gamma_air*c.R_air*T);
mu = 1.716e-5*(T/273.15)^1.5*(273.15+110.4)/(T+110.4);
tau = 1+(c.gamma_air-1)/2*mach^2;
a = struct('Altitude_m',f.Altitude_m,'GeopotentialAltitude_m',H,...
    'T_K',T,'P_Pa',P,'Density_kgm3',rho,'SoundSpeed_ms',sound,...
    'DynamicViscosity_Pas',mu,'KinematicViscosity_m2s',mu/rho,...
    'Gravity_ms2',c.g0*(c.EarthRadius_m/(c.EarthRadius_m+f.Altitude_m))^2,...
    'Mach',mach,'Velocity_ms',mach*sound,'Tt_K',T*tau,...
    'Pt_Pa',P*tau^(c.gamma_air/(c.gamma_air-1)),...
    'DynamicPressure_Pa',.5*rho*(mach*sound)^2);
end
