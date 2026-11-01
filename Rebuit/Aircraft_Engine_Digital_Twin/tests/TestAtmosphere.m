function tests = TestAtmosphere
%TESTATMOSPHERE Analytic/rounded geopotential checkpoints, not claimed ICAO certification.
tests=functiontests(localfunctions);
end
function testSeaLevel(testCase)
a=ISA_model(0); verifyEqual(testCase,a.T_K,288.15,'AbsTol',1e-10);
verifyEqual(testCase,a.P_Pa,101325,'AbsTol',1e-8); verifyEqual(testCase,a.Density_kgm3,1.225,'RelTol',.001);
verifyEqual(testCase,a.SoundSpeed_ms,340.294,'RelTol',.001);
end
function testGeopotentialCheckpoints(testCase)
% Rounded hydrostatic analytical checkpoints; corrupted PDF mixed-altitude cells excluded.
h=[0,2000,5000,8000,11000,15000,20000,25000,32000];
T=[288.15,275.15,255.65,236.15,216.65,216.65,216.65,221.65,228.65];
P=[101325,79495,54020,35600,22632,12045,5475,2511,868];
for i=1:numel(h)
    a=ISA_model(h(i),0,'geopotential'); verifyEqual(testCase,a.T_K,T(i),'AbsTol',1e-8);
    verifyEqual(testCase,a.P_Pa,P(i),'RelTol',.001);
end
end
function testLayerContinuity(testCase)
for h=[11000,20000]
    left=ISA_model(h-1e-5,0,'geopotential'); right=ISA_model(h+1e-5,0,'geopotential');
    verifyEqual(testCase,left.P_Pa,right.P_Pa,'RelTol',1e-7);
    verifyEqual(testCase,left.T_K,right.T_K,'AbsTol',1e-6);
end
end
function testGeometricConversion(testCase)
a=ISA_model(11000); b=ISA_model(a.GeopotentialAltitude_m,0,'geopotential');
verifyLessThan(testCase,a.GeopotentialAltitude_m,11000); verifyEqual(testCase,a.T_K,b.T_K,'AbsTol',1e-9);
verifyEqual(testCase,b.Altitude_m,11000,'AbsTol',1e-8);
end
function testMachStagnation(testCase)
a=ISA_model(0,2); verifyEqual(testCase,a.Tt_K,518.67,'AbsTol',1e-8);
verifyGreaterThan(testCase,a.Pt_Pa,a.P_Pa); verifyGreaterThan(testCase,a.DynamicViscosity_Pas,0);
end
function testNegativeAltitude(testCase)
verifyError(testCase,@() ISA_model(-1),'ABACUS:ERR_ATM_01');
end
function testUpperBound(testCase)
verifyError(testCase,@() ISA_model(32001),'ABACUS:ERR_ATM_01');
verifyError(testCase,@() ISA_model(32001,0,'geopotential'),'ABACUS:ERR_ATM_01');
end
function testInvalidMachAndThrottle(testCase)
verifyError(testCase,@() flight_condition(0,-.1,1),'ABACUS:ERR_MACH_01');
verifyError(testCase,@() flight_condition(0,0,1.01),'ABACUS:ERR_IN_01');
end
