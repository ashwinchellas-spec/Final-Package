function tests = TestSimulink
% Test generated Simulink models against the MATLAB backend.
tests = functiontests(localfunctions);
end

function testBuiltModelsMatchBackend(testCase)
assumeTrue(testCase, logical(license('test','Simulink')));

[db,file] = new_test_database();
delete(db);

folder = tempname;
mkdir(folder);

[~,token] = fileparts(folder);
prefix = matlab.lang.makeValidName(['ABACUS_Test_' token]);
models = {[prefix '_Turbojet'], ...
    [prefix '_Turbofan'], ...
    [prefix '_Turboprop']};

dt = DT_Coordinator(file);

% One cleanup function enforces the required release order.
cleanup = onCleanup(@() close_sim_fixture(dt,file,folder,models));

build_simulink_models(file,folder,prefix);
ids = [1,4,9];

for i = 1:numel(models)
    load_system(fullfile(folder,[models{i} '.slx']));

    result = sim(models{i},'ReturnWorkspaceOutputs','on');
    data = result.get('abacus_output');

    expected = dt.run(ids(i), ...
        flight_condition(0,0,1),'L1',false);

    verifyTrue(testCase,expected.Valid);
    verifyEqual(testCase,data(end,2), ...
        expected.EquivalentThrust_N,'RelTol',1e-9);
    verifyEqual(testCase,data(end,4), ...
        expected.FuelFlow_kgs,'RelTol',1e-9);

    close_system(models{i},0);
end

clear cleanup
end

function close_sim_fixture(dt,file,folder,models)
% Close only this test's models and connection before deleting its files.
for i = 1:numel(models)
    if bdIsLoaded(models{i})
        close_system(models{i},0);
    end
end

if isvalid(dt)
    delete(dt);
end

if isfile(file)
    delete(file);
end

if isfolder(folder)
    rmdir(folder,'s');
end
end
