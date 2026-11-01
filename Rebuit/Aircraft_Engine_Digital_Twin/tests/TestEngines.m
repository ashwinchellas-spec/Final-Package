function tests = TestEngines
%TESTENGINES Test analytic components, mass/work balances and architecture boundaries.
% These are internal model checks; passing them does not prove measured engine accuracy.
tests=functiontests(localfunctions);
end
function setupOnce(testCase)
[testCase.TestData.db,testCase.TestData.file]=new_test_database();
db_seed_piston_extension(testCase.TestData.file);
end
function teardownOnce(testCase)
delete(testCase.TestData.db); delete(testCase.TestData.file);
end
function testIdealCompressionCheckpoint(testCase)
c=project_config(); s=compress_stage(300,100000,2^(c.gamma_air/(c.gamma_air-1)),1,c.cp_air,c.gamma_air);
verifyEqual(testCase,s.Tt_K,600,'AbsTol',1e-8); verifyEqual(testCase,s.Work_Jkg,300*c.cp_air,'RelTol',1e-12);
end
function testNozzleChoked(testCase)
c=project_config(); n=nozzle_model(1000,250000,100000,10,c.gamma_gas,c.R_gas,1);
verifyTrue(testCase,n.Choked); verifyEqual(testCase,n.Mach,1,'AbsTol',1e-10);
verifyGreaterThan(testCase,n.PressureThrust_N,0); verifyEqual(testCase,n.T_K,2000/2.33,'AbsTol',1e-8);
verifyLessThan(testCase,abs(n.EnergyResidual_W),1e-6);
end
function testNozzleUnchoked(testCase)
c=project_config(); n=nozzle_model(1000,150000,100000,10,c.gamma_gas,c.R_gas,.98);
verifyFalse(testCase,n.Choked); verifyLessThan(testCase,n.Mach,1); verifyEqual(testCase,n.P_Pa,100000,'AbsTol',1e-8);
end
function testNozzleBoundaryContinuity(testCase)
c=project_config(); n=nozzle_model(900,300000,100000,5,c.gamma_gas,c.R_gas,.98);
left=nozzle_model(900,100000*n.NPR_critical*(1-1e-8),100000,5,c.gamma_gas,c.R_gas,.98);
right=nozzle_model(900,100000*n.NPR_critical*(1+1e-8),100000,5,c.gamma_gas,c.R_gas,.98);
verifyEqual(testCase,left.GrossThrust_N,right.GrossThrust_N,'RelTol',1e-6);
end
function testNoExpansionRejected(testCase)
verifyError(testCase,@() nozzle_model(900,90000,100000,5,1.33,287.4,.98),'ABACUS:ERR_NOZ_02');
end
function testAllCoreEnginesSLS(testCase)
for id=1:11
    e=db_get_engine(testCase.TestData.db,id); r=simulate_engine(e,flight_condition(0,0,1));
    verifyTrue(testCase,r.Valid,strjoin(r.Warnings,' | ')); verifyGreaterThan(testCase,r.EquivalentThrust_N,0);
    verifyLessThan(testCase,abs(r.Diagnostics.MassResidual_kgs),1e-8);
    verifyLessThan(testCase,abs(r.Diagnostics.ShaftResidual_W),1e-6);
    verifyLessThan(testCase,abs(r.Diagnostics.BurnerResidual_W),1e-6);
end
end
function testTurbofanMassAndFanDemand(testCase)
e=db_get_engine(testCase.TestData.db,4); r=TF_Model(e,flight_condition(0,0,1)); d=r.Diagnostics;
verifyEqual(testCase,d.BypassFlow_kgs/d.CoreFlow_kgs,e.Params.BPR,'RelTol',1e-12);
verifyGreaterThan(testCase,d.FanWork_Jkg,0); verifyTrue(testCase,ismember(18,r.Stations.Station));
verifyEqual(testCase,d.AirFlow_kgs,e.Params.MassFlow_kgs,'RelTol',1e-12);
end
function testTurbopropPowerAndStaticCase(testCase)
e=db_get_engine(testCase.TestData.db,9); r=TP_Model(e,flight_condition(0,0,1));
verifyTrue(testCase,isfinite(r.EquivalentThrust_N)); verifyGreaterThan(testCase,r.ShaftPower_kW,0);
verifyTrue(testCase,ismember(7,r.Stations.Station)); verifyTrue(testCase,isnan(r.Thrust_N));
verifyEqual(testCase,r.BSFC_kgkWh,r.FuelFlow_kgs*3600/r.ShaftPower_kW,'RelTol',1e-12);
verifyGreaterThan(testCase,r.Diagnostics.CoreThrust_N,0);
end
function testPropellerContinuousAndFinite(testCase)
velocities=[0,1e-9,16.999999,17,17.000001]; thrust=zeros(size(velocities));
for i=1:numel(velocities), p=propeller_model(1e6,.8,1.225,3,velocities(i),340,1500); thrust(i)=p.Thrust_N; end
verifyTrue(testCase,all(isfinite(thrust))); verifyEqual(testCase,thrust(1),thrust(2),'RelTol',1e-7);
verifyEqual(testCase,thrust(3),thrust(5),'RelTol',1e-6);
end
function testKaveriWarningAndType(testCase)
e=db_get_engine(testCase.TestData.db,8); r=simulate_engine(e,flight_condition(0,0,1));
verifyEqual(testCase,r.Data_Type,'Simulated_Estimated'); verifyTrue(testCase,any(contains(r.Warnings,'NOT MANUFACTURER-CONFIRMED')));
end
function testAltitudeAndMachEnvelope(testCase)
e=db_get_engine(testCase.TestData.db,9);
r=simulate_engine(e,flight_condition(9500,0,1,'geopotential')); verifyFalse(testCase,r.Valid);
r=simulate_engine(e,flight_condition(0,.56,1)); verifyFalse(testCase,r.Valid);
end
function testAfterburnerRejected(testCase)
e=db_get_engine(testCase.TestData.db,1); r=simulate_engine(e,flight_condition(0,0,1,'geometric',true));
verifyFalse(testCase,r.Valid); verifyEqual(testCase,r.Error_Code,'ABACUS:AfterburnerUnsupported');
end
function testBadEfficiencyAndTemperature(testCase)
e=db_get_engine(testCase.TestData.db,1); e.Params.Eta_compressor=-1;
verifyError(testCase,@() TJ_Model(e,flight_condition(0,0,1)),'ABACUS:Efficiency');
e=db_get_engine(testCase.TestData.db,1); e.Params.T_t4_K=400;
r=simulate_engine(e,flight_condition(0,0,1)); verifyFalse(testCase,r.Valid);
end
function testPistonPowerTorqueAndAltitude(testCase)
e=db_get_engine(testCase.TestData.db,12); sea=Piston_Model(e,flight_condition(0,0,1));
high=Piston_Model(e,flight_condition(3000,0,1));
verifyLessThan(testCase,high.ShaftPower_kW,sea.ShaftPower_kW);
verifyEqual(testCase,sea.Diagnostics.Torque_Nm*e.Params.Rated_RPM*2*pi/60,sea.ShaftPower_kW*1000,'RelTol',1e-12);
verifyLessThan(testCase,sea.Eta_thermal,sea.Diagnostics.IdealOttoEfficiency);
end
function testZeroThrottleState(testCase)
e=db_get_engine(testCase.TestData.db,4); r=simulate_engine(e,flight_condition(0,0,0));
verifyTrue(testCase,r.Valid); verifyEqual(testCase,r.FuelFlow_kgs,0); verifyEqual(testCase,r.EquivalentThrust_N,0);
end
function testChangedParametersInvalidateFingerprint(testCase)
e=db_get_engine(testCase.TestData.db,1); old=e.Fingerprint; e.Params.OPR=e.Params.OPR+1;
verifyNotEqual(testCase,model_fingerprint(e),old);
end
