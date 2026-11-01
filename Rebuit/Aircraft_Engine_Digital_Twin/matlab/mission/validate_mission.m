function w = validate_mission(mission)
%VALIDATE_MISSION Enforce finite conditions, valid constraints and five weights.
% Input: mission struct. Output: 1x5 weights [-]. Ref: ABACUS 21; errors are explicit.
names={'W_Thrust','W_Efficiency','W_Fuel','W_Altitude','W_TWR'};
w=zeros(1,5);
for i=1:5, w(i)=mission.(names{i}); end
if any(~isfinite(w)) || any(w<0 | w>1) || abs(sum(w)-1)>1e-6
    error('ABACUS:MissionWeights','Five weights must be finite, nonnegative and sum to one.');
end
flight_condition(mission.Altitude_m,mission.Mach,1,'geopotential');
validateattributes(mission.Ceiling_m,{'numeric'},{'scalar','real','finite','>=',0,'<=',32000});
allowed=["Turbojet","Turbofan_HighBPR","Turbofan_LowBPR","Turboprop","Piston"];
architectures=strtrim(split(string(mission.Architectures),','));
if any(~ismember(architectures,allowed)), error('ABACUS:MissionArchitecture','Unknown mission architecture.'); end
if any(ismember(architectures,["Turboprop","Piston"])) && any(ismember(architectures,allowed(1:3)))
    error('ABACUS:MissionMetric','A mission ranking cannot mix shaft BSFC and jet TSFC.');
end
for name=["Min_Thrust_N","Max_TSFC_kgNs","Min_Power_kW","Max_BSFC_kgkWh","Max_DryWeight_kg"]
    if isfield(mission,name) && ~isnan(mission.(name))
        validateattributes(mission.(name),{'numeric'},{'real','finite','scalar','nonnegative'});
    end
end
end
