function tests = TestML
%TESTML Test split leakage, fit/predict APIs, metrics, acceptance gate and domain holes.
% Analytic response fixtures are labelled mathematical tests, never engine performance data.
tests=functiontests(localfunctions);
end
function X = analytic_grid()
%ANALYTIC_GRID Deterministic unique inputs for algorithm unit tests only.
[m,h,t]=ndgrid(linspace(0,1,9),linspace(0,10000,9),linspace(.5,1,6)); X=[m(:),h(:),t(:)];
end
function testSplitDeterministicAndDisjoint(testCase)
X=analytic_grid(); a=ml_stratified_split(X,42); b=ml_stratified_split(X,42);
verifyEqual(testCase,a.Train,b.Train); verifyFalse(testCase,any(a.Train&a.Test | a.Train&a.Validation | a.Test&a.Validation));
verifyTrue(testCase,all(a.Train|a.Validation|a.Test)); verifyEqual(testCase,sum(a.ActualFractions),1,'AbsTol',1e-12);
verifyLessThan(testCase,max(abs(a.ActualFractions-[.7,.15,.15])),.035);
for group=unique(a.Group)'
    idx=a.Group==group; verifyTrue(testCase,any(a.Train&idx)); verifyTrue(testCase,any(a.Validation&idx)); verifyTrue(testCase,any(a.Test&idx));
end
end
function testDuplicateInputsRejected(testCase)
X=analytic_grid(); X(end,:)=X(1,:); verifyError(testCase,@() ml_stratified_split(X),'ABACUS:MLDuplicate');
end
function testMetricsKnownErrors(testCase)
t=ml_metrics([1;2;3],[2;3;4],{'AnalyticResponse'});
verifyEqual(testCase,t.RMSE,1,'AbsTol',1e-12); verifyEqual(testCase,t.MAE,1,'AbsTol',1e-12);
verifyEqual(testCase,t.R2,-.5,'AbsTol',1e-12);
end
function testConstantAndZeroTargets(testCase)
t=ml_metrics(ones(4,1),ones(4,1),{'Constant'}); verifyTrue(testCase,isnan(t.R2));
t=ml_metrics([0;1;2],[0;1;2],{'ZeroIncluded'}); verifyEqual(testCase,t.MAPE_Count,2); verifyEqual(testCase,t.MAPE_Percent,0);
end
function testPolynomialTrainPredict(testCase)
X=analytic_grid(); y=2+3*X(:,1)+1e-4*X(:,2)+X(:,3).^2; s=ml_stratified_split(X);
model=ml_fit_candidate(X(s.Train,:),y(s.Train),'Poly',1); prediction=ml_apply_candidate(model,X(s.Test,:));
verifyLessThan(testCase,max(abs(prediction-y(s.Test))),1e-4);
end
function testFourCandidateAPIs(testCase)
assumeTrue(testCase, logical(license('test','Statistics_Toolbox')));
X=analytic_grid(); X=X(1:5:end,:); y=2+X(:,1)+X(:,2)/10000+X(:,3); old=rng; clean=onCleanup(@() rng(old)); rng(42,'twister');
for family={'Poly','RF','GPR','ANN'}
    model=ml_fit_candidate(X,y,family{1},1); prediction=ml_apply_candidate(model,X(1:3,:));
    verifySize(testCase,prediction,[3,1]); verifyTrue(testCase,all(isfinite(prediction)));
end
end
function testMLCellRejectsHolesAndExtrapolation(testCase)
b.Grid=struct('Altitude_m',[0,1000],'Mach',[0,.5],'Throttle',[.5,1]); b.ValidityMask=true(2,2,2);
f=flight_condition(500,.25,.75,'geopotential'); verifyTrue(testCase,ml_domain_valid(b,f));
b.ValidityMask(2,2,2)=false; verifyFalse(testCase,ml_domain_valid(b,f));
verifyFalse(testCase,ml_domain_valid(b,flight_condition(1500,.25,.75,'geopotential')));
end
function testMissingModelAndGate(testCase)
[db,file]=new_test_database(); cleanup=onCleanup(@() close_fixture(db,file));
e=db_get_engine(db,1); e.ID=2147483647;
[~,available,message]=ml_predict(e,flight_condition(0,0,1)); verifyFalse(testCase,available);
verifyTrue(testCase,contains(message,'physics')); verifyError(testCase,@() require_validation(e),'ABACUS:ValidationRequired');
end
function close_fixture(db,file)
%CLOSE_FIXTURE Close the temporary database before removing it on all paths.
delete(db); delete(file);
end
