function c = project_config()
%PROJECT_CONFIG Central physical constants and reproducibility settings.
% Inputs: none. Output: SI constants c. Ref: ABACUS 16-17 and CHANGELOG C04.
% cp is derived from R and gamma for internal thermodynamic consistency.
c.Version = 'ABACUS-1.1-rebuild-1.1';
c.SchemaVersion = 2;
c.RandomSeed = 42;
c.EarthRadius_m = 6356766;
c.g0 = 9.80665;
c.T0_K = 288.15;
c.P0_Pa = 101325;
c.R_air = 287.058;
c.gamma_air = 1.4;
c.R_gas = 287.4;
c.gamma_gas = 1.33;
c.cp_air = c.gamma_air*c.R_air/(c.gamma_air-1);
c.cp_gas = c.gamma_gas*c.R_gas/(c.gamma_gas-1);
c.FuelLHV_Jkg = 43.2e6;
c.KaveriWarning = 'ESTIMATED / ACADEMIC MODEL - NOT MANUFACTURER-CONFIRMED PERFORMANCE. These results do NOT represent actual Kaveri engine performance.';
c.Scope = 'Academic steady-state software Digital Twin';
c.MinimumML_R2 = 0.95;
c.MLFeatures = {'Mach','GeopotentialAltitude_m','Throttle'};
end
