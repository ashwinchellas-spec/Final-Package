function tests = TestIntegration
%TESTINTEGRATION Exercise the real DB -> physics -> DT -> grid/comparison/report path.
tests=functiontests(localfunctions);
end
function setupOnce(testCase)
[db,file]=new_test_database(); delete(db);
testCase.TestData.file=file; testCase.TestData.dt=DT_Coordinator(file);
end
function teardownOnce(testCase)
delete(testCase.TestData.dt); delete(testCase.TestData.file);
end
function testPersistenceAndLog(testCase)
dt=testCase.TestData.dt; before=height(dt.Database.read('Performance_Data'));
r=dt.run(1,flight_condition(0,0,1),'L4',true);
verifyTrue(testCase,r.Valid); t=dt.Database.read('Performance_Data'); verifyEqual(testCase,height(t),before+1);
verifyEqual(testCase,string(t.Data_Type(end)),"Simulated_Estimated");
logs=dt.Database.read('Simulation_Log'); verifyTrue(testCase,contains(string(logs.Outputs_JSON(end)),'CoreNozzle'));
end
function testFailedPointLogsWithoutPerformance(testCase)
dt=testCase.TestData.dt; before=height(dt.Database.read('Performance_Data')); n=height(dt.Database.read('Simulation_Log'));
r=dt.run(9,flight_condition(10000,0,1),'L4',true); verifyFalse(testCase,r.Valid);
verifyEqual(testCase,height(dt.Database.read('Performance_Data')),before);
verifyEqual(testCase,height(dt.Database.read('Simulation_Log')),n+1);
end
function testLogImmutable(testCase)
dt=testCase.TestData.dt; dt.run(1,flight_condition(0,0,1),'L4',true); failed=false;
try, execute(dt.Database.Connection,'DELETE FROM Simulation_Log'); catch, failed=true; end
verifyTrue(testCase,failed);
end
function testArchitectureGridCounts(testCase)
db=testCase.TestData.dt.Database;
for id=[1,6], e=db_get_engine(db,id); g=performance_grid(e); verifyEqual(testCase,g.CandidateCount,1134); end
for id=[4,9], e=db_get_engine(db,id); g=performance_grid(e); verifyEqual(testCase,g.CandidateCount,1008); end
end
function testGridValidityMaskAndTemperatureFields(testCase)
dt=testCase.TestData.dt; e=db_get_engine(dt.Database,9);
t=evaluate_grid(e,[0,9500],[0,.7],1,dt.Database,false,'L3');
verifyEqual(testCase,height(t),4); verifyEqual(testCase,nnz(t.Valid),1);
verifyTrue(testCase,all(isnan(t.FuelFlow_kgs(~logical(t.Valid))))); verifyGreaterThan(testCase,t.T_t4_K(1),0);
end
function testCompatibleComparison(testCase)
t=compare_engines(testCase.TestData.dt,[1,2],flight_condition(0,0,1),'Thrust_N');
verifyEqual(testCase,height(t),2); verifyGreaterThanOrEqual(testCase,t.Thrust_N(1),t.Thrust_N(2));
end
function testIncompatibleComparisonRejected(testCase)
verifyError(testCase,@() compare_engines(testCase.TestData.dt,[1,9],flight_condition(0,0,1),'TSFC_kgNs'),'ABACUS:IncompatibleMetric');
end
function testAllMissionPresets(testCase)
for id=1:7
    s=EngineSelector(testCase.TestData.dt,id,[],false);
    verifyTrue(testCase,isfield(s,'Eliminated')); verifyGreaterThan(testCase,strlength(s.Message),0);
    if ~isempty(s.Ranking), verifyTrue(testCase,all(strlength(s.Ranking.EliminationReason)==0)); end
end
end
function testUnverifiedReferencesCannotPass(testCase)
t=validate_references(testCase.TestData.dt.Database); verifyFalse(testCase,any(t.Status=="PASS"));
verifyEqual(testCase,height(t),13);
end
function testReportingContainsProvenance(testCase)
r=testCase.TestData.dt.run(8,flight_condition(0,0,1),'L1',false);
folder=tempname; mkdir(folder); cleanup=onCleanup(@() rmdir(folder,'s'));
file=generate_report(r,table(),struct(),table(),folder); html=fileread(file);
verifyTrue(testCase,contains(html,'NOT MANUFACTURER-CONFIRMED')); verifyTrue(testCase,contains(html,'Parameter provenance'));
verifyTrue(testCase,isfile(fullfile(folder,'ABACUS_session_data.json')));
end
function testOutputUnitConversion(testCase)
r=testCase.TestData.dt.run(1,flight_condition(0,0,1),'L1',false);
a=format_result_metrics(r,'SI'); b=format_result_metrics(r,'Imperial');
verifyEqual(testCase,a.Value(a.Quantity=="Thrust_N"),r.Thrust_N/1000,'RelTol',1e-12);
verifyEqual(testCase,b.Value(b.Quantity=="Thrust_N"),r.Thrust_N/4.4482216152605,'RelTol',1e-12);
verifyEqual(testCase,a.Value(a.Quantity=="TSFC_kgNs"),r.TSFC_kgNs*3.6e6,'RelTol',1e-12);
end
function testHTMLTextEscaped(testCase)
verifyEqual(testCase,html_escape('<script>&"'), '&lt;script&gt;&amp;&quot;');
end
