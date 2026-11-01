function tests = TestRebuild
%TESTREBUILD Regression cases for explicit SQL transactions and altitude study.
tests = functiontests(localfunctions);
end
function setup(testCase)
folder = tempname; mkdir(folder);
testCase.TestData.folder = folder;
testCase.TestData.file = fullfile(folder,'test.db');
db_initialize(testCase.TestData.file); db_seed(testCase.TestData.file);
testCase.TestData.db = DB_Interface(testCase.TestData.file);
end
function teardown(testCase)
delete(testCase.TestData.db);
rmdir(testCase.TestData.folder,'s');
end
function testRepeatAndEmptyScriptTransactions(testCase)
db = testCase.TestData.db;
db_seed(testCase.TestData.file); db_seed(testCase.TestData.file);
file = fullfile(testCase.TestData.folder,'empty.sql'); write_text(file,'');
db_execute_script(db.Connection,file);
verifyEqual(testCase,height(db.read('Engines')),11);
verifyEqual(testCase,db.Connection.AutoCommit,'on');
end
function testSQLFailureRollsBackAndRetainsCause(testCase)
db = testCase.TestData.db; before = height(db.read('Manufacturers'));
file = fullfile(testCase.TestData.folder,'fail.sql');
write_text(file,sprintf(['INSERT INTO Manufacturers(Manufacturer_ID,Name,Country) ', ...
    'VALUES(999,''Regression entry'',''Test'');\n-- @statement\n', ...
    'INSERT INTO MissingRegressionTable VALUES(1);\n']));
failed = false;
try
    db_execute_script(db.Connection,file);
catch exception
    failed = true;
    verifyEqual(testCase,exception.identifier,'ABACUS:SQLScript');
    verifyTrue(testCase,contains(getReport(exception),'MissingRegressionTable'));
end
verifyTrue(testCase,failed);
verifyEqual(testCase,height(db.read('Manufacturers')),before);
end
function testAltitudeStudyPreservesInvalidPoints(testCase)
output = run_altitude_study([0,15000],0.3,1,[1,12],false,false, ...
    fullfile(testCase.TestData.folder,'study'),testCase.TestData.file);
t = output.Results; verifyEqual(testCase,height(t),4);
mask = t.Engine_ID==12 & t.Altitude_m==15000;
verifyEqual(testCase,nnz(mask),1); verifyEqual(testCase,t.Valid(mask),0);
verifyTrue(testCase,isnan(t.ShaftPower_kW(mask)));
verifyTrue(testCase,contains(t.Warnings(mask),'envelope'));
verifyTrue(testCase,isfile(fullfile(output.Folder,'altitude_performance.csv')));
verifyEqual(testCase,height(testCase.TestData.db.read('Engines')),13);
end
function testAltitudePersistence(testCase)
output = run_altitude_study(0,0,1,1,false,true, ...
    fullfile(testCase.TestData.folder,'stored'),testCase.TestData.file);
verifyTrue(testCase,startsWith(output.DatabaseStatus,'Stored'));
verifyEqual(testCase,height(testCase.TestData.db.read('Simulation_Log')),1);
verifyEqual(testCase,nnz(output.Results.Valid),1);
end
