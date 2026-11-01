function model = ml_fit_candidate(X,Y,family,setting)
%ML_FIT_CANDIDATE Fit one family to training data only, with train-only scaling.
% Inputs: X n-by-3, Y n-by-target, family, hyperparameter setting. Output: model struct.
% Ref: ABACUS 20.3. ANN uses fitrnet (Statistics Toolbox, R2021a+), one target at a time.
if nargin<4, setting=1; end
validateattributes(X,{'numeric'},{'2d','finite','real','ncols',3});
validateattributes(Y,{'numeric'},{'2d','finite','real','nrows',size(X,1)});
family=char(validatestring(family,{'Poly','RF','GPR','ANN'}));
mu=mean(X,1); sigma=std(X,0,1); sigma(sigma==0)=1; Z=(X-mu)./sigma;
yMu=mean(Y,1); ySigma=std(Y,0,1); ySigma(ySigma==0)=1; target=(Y-yMu)./ySigma;
model=struct('Family',family,'Setting',setting,'Mu',mu,'Sigma',sigma,...
    'YMu',yMu,'YSigma',ySigma,'Objects',{cell(1,size(Y,2))});
for j=1:size(Y,2)
    y=target(:,j);
    switch family
        case 'Poly'
            degree=3+2*(setting==2); [A,powers]=ml_polynomial_features(Z,degree);
            lambda=1e-6; penalty=eye(size(A,2)); penalty(1,1)=0;
            beta=[A;sqrt(lambda)*penalty]\[y;zeros(size(A,2),1)];
            model.Objects{j}=struct('Beta',beta,'Powers',powers,'Degree',degree);
        case 'RF'
            trees=100+100*(setting==2);
            model.Objects{j}=TreeBagger(trees,Z,y,'Method','regression','MinLeafSize',2,...
                'NumPredictorsToSample',2,'OOBPrediction','off');
        case 'GPR'
            kernels={'ardsquaredexponential','ardmatern52'};
            model.Objects{j}=fitrgp(Z,y,'KernelFunction',kernels{setting},'Standardize',false,...
                'FitMethod','exact','PredictMethod','exact');
        case 'ANN'
            sizes={[64,32,16],[32,16]};
            model.Objects{j}=fitrnet(Z,y,'LayerSizes',sizes{setting},'Activations','relu',...
                'Lambda',1e-4,'Standardize',false,'IterationLimit',500);
    end
end
end
