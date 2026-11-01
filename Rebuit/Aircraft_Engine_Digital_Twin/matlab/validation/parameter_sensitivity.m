function t = parameter_sensitivity(dt,id,f,parameter,relativeChange)
%PARAMETER_SENSITIVITY Report local parameter sensitivity without fitting or DB mutation.
% Inputs: DT, engine ID, flight f, numeric parameter name, fractional perturbation.
% Output: three SI result rows. Overrides are explicitly marked Assumed in provenance.
if nargin<5, relativeChange=.02; end
validateattributes(relativeChange,{'numeric'},{'scalar','real','finite','>',0,'<',.5});
e=db_get_engine(dt.Database,id);
if ~isfield(e.Params,parameter) || ~isnumeric(e.Params.(parameter)) || ~isfinite(e.Params.(parameter))
    error('ABACUS:SensitivityParameter','Choose a populated numerical parameter.');
end
rows=cell(3,1); factors=[1-relativeChange,1,1+relativeChange];
for i=1:3
    varied=e; varied.Params.(parameter)=e.Params.(parameter)*factors(i);
    mask=string(varied.Provenance.Parameter_Name)==string(parameter);
    varied.Provenance.Parameter_Value(mask)=varied.Params.(parameter);
    varied.Provenance.Source_Type(mask)="Assumed"; varied.Provenance.Confidence_Level(mask)="Low";
    varied.Provenance.Source_Reference(mask)="Local sensitivity perturbation; no parameter calibration";
    varied.Estimated=true; varied.Confidence='Low'; varied.Fingerprint=model_fingerprint(varied);
    r=simulate_engine(varied,f); rows{i}=result_row(r);
    rows{i}.VariedParameter=string(parameter); rows{i}.ParameterValue=varied.Params.(parameter);
end
t=vertcat(rows{:});
end
