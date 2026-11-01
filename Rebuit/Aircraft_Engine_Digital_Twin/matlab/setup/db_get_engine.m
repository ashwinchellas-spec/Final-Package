function e = db_get_engine(db, identifier)
%DB_GET_ENGINE Load one engine and verify value-level provenance before modelling.
% Inputs: DB_Interface handle; numeric ID or exact designation. Output: engine struct.
% Units: all parameter values SI; rejects missing values/provenance or invalid IDs.
catalogue = db.read('Engines');
if isnumeric(identifier)
    validateattributes(identifier,{'numeric'},{'scalar','finite','integer','positive'});
    mask = catalogue.Engine_ID == identifier;
else
    validateattributes(string(identifier),{'string'},{'scalar'});
    mask = string(catalogue.Designation) == string(identifier);
end
if nnz(mask) ~= 1, error('ABACUS:InvalidEngine','Engine identifier is not in this database.'); end
row = catalogue(mask,:); params = db.read('Engine_Thermo_Params');
params = params(params.Engine_ID == row.Engine_ID,:);
if height(params) ~= 1, error('ABACUS:MissingParameters','Engine has no unique parameter record.'); end
types = db.read('Engine_Types'); kind = types(types.Type_ID == row.Type_ID,:);
provenance = db.read('Parameter_Provenance');
provenance = provenance(provenance.Engine_ID == row.Engine_ID,:);
p = table2struct(params); fields = fieldnames(p);
for i = 1:numel(fields)
    key = fields{i}; value = p.(key);
    if ismember(key,{'Param_ID','Engine_ID','Overall_Confidence'}) || ~isnumeric(value) || isnan(value), continue; end
    match = string(provenance.Parameter_Name) == key;
    if nnz(match) ~= 1 || abs(provenance.Parameter_Value(match)-value) > max(1e-12,abs(value)*1e-12)
        error('ABACUS:MissingProvenance','Missing or mismatched provenance for %s.',key);
    end
end
e = struct('ID',row.Engine_ID,'Name',char(string(row.Designation)),...
    'Type',char(string(kind.Type_Name)),'AfterburnerAvailable',logical(row.Afterburner),...
    'Params',p,'Provenance',provenance,'Confidence',char(string(p.Overall_Confidence)));
e.IsKaveri = contains(e.Name,'Kaveri','IgnoreCase',true);
e.Estimated = any(ismember(string(provenance.Source_Type),["Estimated","Assumed"])) || e.IsKaveri;
e.Fingerprint = model_fingerprint(e);
end
