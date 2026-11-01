function mission = load_mission(db,id)
%LOAD_MISSION Retrieve an exact named or numbered preset from Mission_Profiles.
% Inputs: DB handle, ID/name. Output: mission struct in SI and geopotential m.
% Ref: ABACUS Table 21.2. Missing/ambiguous presets are rejected.
t=db.read('Mission_Profiles');
if isnumeric(id), match=t.Mission_ID==id; else, match=string(t.Mission_Name)==string(id); end
if nnz(match)~=1, error('ABACUS:MissionID','Mission preset not found.'); end
mission=table2struct(t(match,:));
end
