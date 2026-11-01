function split = ml_stratified_split(X,seed)
%ML_STRATIFIED_SPLIT Approximately 70/15/15 within joint altitude/Mach bins.
% Input: unique [Mach,H_m,throttle] rows, RNG seed. Output: disjoint index masks.
% Ref: ABACUS 20.4. Small bins are reported; no target data influence the split.
if nargin<2, seed=42; end
validateattributes(X,{'numeric'},{'2d','real','finite','ncols',3});
if size(X,1)<40, error('ABACUS:MLSampleCount','At least 40 unique operating points are required.'); end
if size(unique(X,'rows'),1)~=size(X,1), error('ABACUS:MLDuplicate','Duplicate operating points would leak across splits.'); end
old=rng; cleanup=onCleanup(@() rng(old)); rng(seed,'twister');
bins=zeros(size(X,1),2);
for j=1:2
    values=X(:,j); lo=min(values); hi=max(values);
    if lo==hi, bins(:,j)=1; else, bins(:,j)=discretize(values,linspace(lo,hi+eps(max(1,abs(hi)))*4,5)); end
end
group=bins(:,1)+4*(bins(:,2)-1); train=false(size(group)); val=train; test=train; sparse=[];
for id=unique(group)'
    indices=find(group==id); indices=indices(randperm(numel(indices))); n=numel(indices);
    if n<3
        train(indices)=true; sparse(end+1)=id; %#ok<AGROW>
    else
        nTrain=min(n-2,max(1,round(.7*n))); nVal=min(n-nTrain-1,max(1,round(.15*n)));
        train(indices(1:nTrain))=true; val(indices(nTrain+1:nTrain+nVal))=true;
        test(indices(nTrain+nVal+1:end))=true;
    end
end
split=struct('Train',train,'Validation',val,'Test',test,'Group',group,'Seed',seed,...
    'ActualFractions',[mean(train),mean(val),mean(test)],'SparseGroups',sparse);
if ~any(val) || ~any(test), error('ABACUS:MLSplit','Not enough points to construct stratified validation/test sets.'); end
end
