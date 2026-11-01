function validation = validate_physics(databaseFile)
%VALIDATE_PHYSICS Run internal physics tests, then independent-reference Track A.
% Input: optional DB file. Outputs: actual test results and fingerprinted certificates.
% No training certificate is accepted without executed tests and verified Track A PASS.
p=project_paths(); addpath(p.tests); if nargin<1, databaseFile=p.database_file; end
suite=matlab.unittest.TestSuite.fromFile(fullfile(p.tests,'TestAtmosphere.m'));
suite=[suite,matlab.unittest.TestSuite.fromFile(fullfile(p.tests,'TestEngines.m'))];
runner=matlab.unittest.TestRunner.withTextOutput; testResults=runner.run(suite);
internal=all([testResults.Passed]);
db=DB_Interface(databaseFile); cleanup=onCleanup(@() delete(db));
trackA=validate_references(db); writetable(trackA,fullfile(p.reports,'track_a_validation.csv'));
engines=db.read('Engines'); certificates=cell(height(engines),1);
for i=1:height(engines)
    e=db_get_engine(db,engines.Engine_ID(i)); rows=trackA(trackA.Engine_ID==e.ID & trackA.SourceVerified,:);
    accepted=internal && ~isempty(rows) && all(rows.Status=="PASS");
    cert=struct('Engine_ID',e.ID,'Engine',e.Name,'Fingerprint',e.Fingerprint,...
        'InternalTestsPassed',internal,'ReferenceAccepted',accepted,'AcceptedForML',accepted,...
        'Timestamp_UTC',utc_timestamp(),'TrackA',table2struct(trackA(trackA.Engine_ID==e.ID,:)),...
        'Note','Only source-reviewed, in-tolerance reference comparisons open the default ML gate. Estimated-target comparisons retain their academic classification.');
    write_text(fullfile(p.reports,sprintf('validation_engine_%d.json',e.ID)),jsonencode(cert,'PrettyPrint',true));
    certificates{i}=cert;
end
validation=struct('InternalTests',testResults,'TrackA',trackA,'Certificates',{certificates});
end
