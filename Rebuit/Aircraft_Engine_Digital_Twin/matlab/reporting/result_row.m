function t = result_row(r)
%RESULT_ROW Flatten one result for grids/CSV without losing validity or provenance.
% Input: standard result. Output: one-row table, SI units indicated in column names.
% NaNs are retained for rejected/inapplicable outputs; no imputation is performed.
f=r.Condition;
s=struct('Engine_ID',r.Engine_ID,'Engine',string(r.Engine),'Architecture',string(r.Architecture),...
    'Altitude_m',f.Altitude_m,'GeopotentialAltitude_m',f.GeopotentialAltitude_m,...
    'Mach',f.Mach,'Throttle',f.Throttle,'Afterburner',double(f.Afterburner));
fields={'Thrust_N','EquivalentThrust_N','ShaftPower_kW','FuelFlow_kgs','TSFC_kgNs',...
    'BSFC_kgkWh','Eta_thermal','Eta_propulsive','Eta_overall','T_t4_K','P_t3_Pa','ESHP'};
for i=1:numel(fields), s.(fields{i})=r.(fields{i}); end
s.Valid=double(r.Valid); s.Status=string(r.Status); s.Error_Code=string(r.Error_Code);
s.Data_Type=string(r.Data_Type); s.Prediction_Source=string(r.Prediction_Source);
s.Confidence=string(r.Confidence); s.Warnings=strjoin(string(r.Warnings),' | ');
s.Core_Nozzle_State=string(r.Core_Nozzle_State); s.Bypass_Nozzle_State=string(r.Bypass_Nozzle_State);
s.Model_Version=string(r.Model_Version); s.Model_Fingerprint=string(r.Model_Fingerprint);
s.ML_Model_Type=string(r.ML_Model_Type); s.Timestamp_UTC=string(r.Timestamp_UTC);
t=struct2table(s);
end
