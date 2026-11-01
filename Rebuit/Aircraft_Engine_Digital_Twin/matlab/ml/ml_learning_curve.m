function curve = ml_learning_curve(data,family,targetIndex)
%ML_LEARNING_CURVE Assess sample-size sensitivity on validation data only.
% Inputs: current synthetic dataset, family, target index. Output: size/error table.
% Training subsets are deterministic. Test set remains untouched. Ref: ABACUS 23.3.
if nargin<3, targetIndex=1; end
train=find(data.Split.Train); val=data.Split.Validation; old=rng; clean=onCleanup(@() rng(old)); rng(42,'twister');
train=train(randperm(numel(train))); fractions=[.25,.5,.75,1]; pieces=cell(4,1);
for i=1:4
    count=max(10,round(fractions(i)*numel(train))); count=min(count,numel(train)); subset=train(1:count);
    model=ml_fit_candidate(data.X(subset,:),data.Y(subset,targetIndex),family,1);
    prediction=ml_apply_candidate(model,data.X(val,:)); metric=ml_metrics(data.Y(val,targetIndex),prediction,data.TargetNames(targetIndex));
    metric.TrainingCount=count; pieces{i}=metric;
end
curve=vertcat(pieces{:});
end
