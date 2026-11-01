function tests = TestDatabase
%TESTDATABASE Execute real native SQLite constraints, provenance and transaction checks.
tests=functiontests(localfunctions);
end
function setup(testCase)
[testCase.TestData.db,testCase.TestData.file]=new_test_database();
end
function teardown(testCase)
delete(testCase.TestData.db); delete(testCase.TestData.file);
end
function testAllTablesAndEngines(testCase)
db=testCase.TestData.db; t=db.read('Engines'); verifyEqual(testCase,height(t),11);
names={'Manufacturers','Engine_Types','Engines','Engine_Thermo_Params','Parameter_Provenance',...
    'Aircraft','Engine_Aircraft_Map','Performance_Data','Mission_Profiles','References','Simulation_Log'};
for i=1:numel(names), verifyTrue(testCase,istable(db.read(names{i}))); end
end
function testSeedIdempotent(testCase)
db_seed(testCase.TestData.file); verifyEqual(testCase,height(testCase.TestData.db.read('Engines')),11);
verifyEqual(testCase,height(testCase.TestData.db.read('Performance_Data')),13);
end
function testProvenanceAudit(testCase)
for id=1:11
    e=db_get_engine(testCase.TestData.db,id); verifyGreaterThan(testCase,height(e.Provenance),10);
    verifyTrue(testCase,all(string(e.Provenance.Confidence_Level)=="Low"));
end
end
function testForeignKeyFailure(testCase)
db=testCase.TestData.db;
t=table(900,"Boundary test",999,1,'VariableNames',{'Engine_ID','Designation','Manufacturer_ID','Type_ID'});
failed=false; try, db.append('Engines',t); catch, failed=true; end
verifyTrue(testCase,failed); verifyEqual(testCase,height(db.read('Engines')),11);
end
function testLiteralTextRoundTrip(testCase)
% Deliberately hostile-looking text must remain a typed value, never SQL syntax.
value="O'Brien'); DROP TABLE Engines; --";
t=table(900,value,"Test",'VariableNames',{'Manufacturer_ID','Name','Country'});
db=testCase.TestData.db; db.append('Manufacturers',t); all=db.read('Manufacturers');
verifyEqual(testCase,string(all.Name(all.Manufacturer_ID==900)),value); verifyEqual(testCase,height(db.read('Engines')),11);
end
function testAtomicRollback(testCase)
db=testCase.TestData.db; before=height(db.read('Manufacturers')); failed=false;
try, db.atomic(@() write_then_fail(db)); catch, failed=true; end
verifyTrue(testCase,failed); verifyEqual(testCase,height(db.read('Manufacturers')),before);
end
function write_then_fail(db)
% Two-row transaction fixture: first write valid, then a deliberate failure.
db.append('Manufacturers',table(900,"Transaction test","Test",'VariableNames',{'Manufacturer_ID','Name','Country'}));
error('ABACUS:IntentionalTestFailure','Exercise atomic rollback.');
end
function testImmutableReference(testCase)
db=testCase.TestData.db; failed=false;
try, execute(db.Connection,'UPDATE Performance_Data SET Thrust_N=1 WHERE Data_ID=1'); catch, failed=true; end
verifyTrue(testCase,failed); t=db.read('Performance_Data'); verifyEqual(testCase,t.Thrust_N(t.Data_ID==1),52800);
end
function testMissingProvenanceRejected(testCase)
db=testCase.TestData.db; execute(db.Connection,'DELETE FROM Parameter_Provenance WHERE Engine_ID=1 AND Parameter_Name=''OPR''');
verifyError(testCase,@() db_get_engine(db,1),'ABACUS:MissingProvenance');
end
function testInvalidEngineID(testCase)
verifyError(testCase,@() db_get_engine(testCase.TestData.db,99999),'ABACUS:InvalidEngine');
end
function testSchemaConstraints(testCase)
db=testCase.TestData.db; failed=false;
try, execute(db.Connection,'UPDATE Engine_Thermo_Params SET Eta_turbine=-1 WHERE Engine_ID=1'); catch, failed=true; end
verifyTrue(testCase,failed);
failed=false; try, execute(db.Connection,'UPDATE Mission_Profiles SET W_Thrust=1 WHERE Mission_ID=1'); catch, failed=true; end
verifyTrue(testCase,failed);
end
