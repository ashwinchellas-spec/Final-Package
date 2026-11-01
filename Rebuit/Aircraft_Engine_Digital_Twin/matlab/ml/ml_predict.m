function [r,available,message] = ml_predict(e,f)
%ML_PREDICT Load the selected current surrogate and enforce domain/accuracy bounds.
% Inputs: loaded engine and flight f. Outputs: result, availability, fallback reason.
% Ref: ABACUS L5. Missing toolbox/model, stale model and invalid cells fall back safely.
r=result_template(e,f); available=false; message="ML surrogate not available; physics model used.";
p=project_paths(); filename=fullfile(p.ml_models,sprintf('engine_%d_best.mat',e.ID));
if ~isfile(filename), return; end
predictionTimer=tic;
try
    warnings=validate_inputs(e,f); loaded=load(filename,'bundle'); b=loaded.bundle;
    if ~strcmp(b.Fingerprint,e.Fingerprint), message="ML model is stale after model/data changes; physics model used."; return; end
    if ~b.Operational, message="ML model did not meet measured acceptance criteria; physics model used."; return; end
    if ~ml_domain_valid(b,f), message="Query outside validated ML cells; physics model used."; return; end
    prediction=ml_apply_candidate(b.Model,[f.Mach,f.GeopotentialAltitude_m,f.Throttle]);
    for i=1:numel(b.TargetNames), r.(b.TargetNames{i})=prediction(i); end
    a=ISA_model(f.GeopotentialAltitude_m,f.Mach,'geopotential'); c=project_config();
    if ismember(e.Type,{'Turboprop','Piston'})
        r.PropShaftPower_kW=r.ShaftPower_kW; r.FuelFlow_kgs=r.BSFC_kgkWh*r.ShaftPower_kW/3600;
    else
        r.EquivalentThrust_N=r.Thrust_N; r.FuelFlow_kgs=r.TSFC_kgNs*r.Thrust_N;
    end
    LHV=c.FuelLHV_Jkg; if strcmp(e.Type,'Piston'), LHV=e.Params.Fuel_LHV_Jkg; end
    r.Eta_overall=r.EquivalentThrust_N*a.Velocity_ms/(r.FuelFlow_kgs*LHV);
    if ~ismember('Eta_propulsive',b.TargetNames), r.Eta_propulsive=r.Eta_overall/r.Eta_thermal; end
    if abs(r.Eta_overall-r.Eta_thermal*r.Eta_propulsive)>.03
        message="ML efficiency identities disagree beyond tolerance; physics model used."; return
    end
    r.Prediction_Source='ML'; r.Data_Type='ML_Predicted'; r.ML_Model_Type=b.Model.Family;
    r.Warnings=[warnings;"ML approximates synthetic physics data; it does not validate real engine performance."];
    r.Diagnostics=struct('TestMetrics',b.TestMetrics,'RawPrediction',prediction,'Label',b.Label);
    r=validate_outputs(r); r.Elapsed_ms=toc(predictionTimer)*1000; available=true; message="ML prediction available.";
catch exception
    message="ML unavailable ("+string(exception.message)+"); physics model used.";
end
end
