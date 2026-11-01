function tests = TestMission
%TESTMISSION Deliberate algorithm boundary fixtures; numbers are not engine data.
tests=functiontests(localfunctions);
end
function [t,m] = boundary_fixture()
%BOUNDARY_FIXTURE Two hypothetical constraint candidates used only for algorithm tests.
t=table([1;1],["Turbojet";"Turbojet"],[1;1],[100;200],[.001;.002],[NaN;NaN],[NaN;NaN],[100;200],...
    'VariableNames',{'Valid','Architecture','Ceiling_OK','EquivalentThrust_N','TSFC_kgNs','ShaftPower_kW','BSFC_kgkWh','DryWeight_kg'});
m=struct('Altitude_m',0,'Mach',0,'Ceiling_m',0,'Architectures','Turbojet','Min_Thrust_N',0,...
    'W_Thrust',.2,'W_Efficiency',.2,'W_Fuel',.2,'W_Altitude',.2,'W_TWR',.2);
end
function testNormalisationDirections(testCase)
verifyEqual(testCase,normalise_metric([100;200],true),[0;1]); verifyEqual(testCase,normalise_metric([100;200],false),[1;0]);
end
function testTieAndSingleMetric(testCase)
[s,tied]=normalise_metric([100;100]); verifyEqual(testCase,s,[.5;.5]); verifyTrue(testCase,tied);
verifyEqual(testCase,normalise_metric(100),.5);
end
function testAllEliminated(testCase)
[t,m]=boundary_fixture(); m.Min_Thrust_N=300; [mask,reasons]=apply_hard_constraints(t,m);
verifyFalse(testCase,any(mask)); verifyTrue(testCase,all(contains(reasons,'Min_Thrust_N')));
end
function testOnlyOneSurvives(testCase)
[t,m]=boundary_fixture(); m.Min_Thrust_N=150; verifyEqual(testCase,apply_hard_constraints(t,m),[false;true]);
end
function testHighScoreCannotOverrideConstraint(testCase)
[t,m]=boundary_fixture(); m.Max_DryWeight_kg=150; m.W_Thrust=1; m.W_Efficiency=0; m.W_Fuel=0; m.W_Altitude=0; m.W_TWR=0;
verifyEqual(testCase,apply_hard_constraints(t,m),[true;false]);
end
function testArchitectureAndCeiling(testCase)
[t,m]=boundary_fixture(); t.Architecture(1)="Turboprop"; t.Ceiling_OK(2)=false;
verifyFalse(testCase,any(apply_hard_constraints(t,m)));
end
function testWeightsRejected(testCase)
[~,m]=boundary_fixture(); m.W_Thrust=.9; verifyError(testCase,@() validate_mission(m),'ABACUS:MissionWeights');
end
function testMixedSFCRejected(testCase)
[~,m]=boundary_fixture(); m.Architectures='Turbojet,Turboprop'; verifyError(testCase,@() validate_mission(m),'ABACUS:MissionMetric');
end
