function db_add_reference(db,record,verificationNote)
%DB_ADD_REFERENCE Add explicitly reviewed public reference data as an immutable row.
% Inputs: DB handle, scalar struct containing exact SI condition/value/source, review note.
% Output: appended Reference row. This API records the caller's review; it does not verify URLs.
% Estimated targets require their own kind and Low confidence; never call them measurements.
needed={'Engine_ID','GeopotentialAltitude_m','Mach','Throttle','Source_Ref','Reference_Kind'};
for i=1:numel(needed)
    if ~isfield(record,needed{i}), error('ABACUS:ReferenceInput','Missing %s.',needed{i}); end
end
if strlength(string(verificationNote))<20 || ~startsWith(string(record.Source_Ref),["https://","http://"])
    error('ABACUS:ReferenceReview','Provide the exact public source URL and a review note identifying document, page, units and rating.');
end
e=db_get_engine(db,record.Engine_ID);
kind=validatestring(char(record.Reference_Kind),{'Measured','PublishedRating','EstimatedTarget'});
if e.IsKaveri && ~strcmp(kind,'EstimatedTarget')
    error('ABACUS:EstimatedReference','Kaveri references must remain explicitly estimated targets under ABACUS.');
end
f=flight_condition(record.GeopotentialAltitude_m,record.Mach,record.Throttle,'geopotential');
record.Altitude_m=f.Altitude_m; record.Data_Type="Reference"; record.Prediction_Source="Reference";
record.Reference_Verified=1; record.Reference_Kind=string(kind);
if ~isfield(record,'Confidence'), record.Confidence="Low"; end
record.Confidence=string(validatestring(char(record.Confidence),{'High','Medium','Low'}));
if strcmp(kind,'EstimatedTarget'), record.Confidence="Low"; end
record.Warnings=string(verificationNote);
if strcmp(kind,'EstimatedTarget'), record.Warnings=record.Warnings+" | Estimated academic target, not measured engine performance."; end
record.Timestamp_UTC=string(utc_timestamp()); record.Source_Ref=string(record.Source_Ref);
if ~isfield(record,'FuelFlow_kgs'), record.FuelFlow_kgs=NaN; end
if ~isfield(record,'Thrust_N') && ~isfield(record,'ShaftPower_kW')
    error('ABACUS:ReferenceMetric','Supply measured/rated Thrust_N or ShaftPower_kW with the exact condition.');
end
for metric=["Thrust_N","ShaftPower_kW","TSFC_kgNs","BSFC_kgkWh"]
    if isfield(record,metric) && ~isnan(record.(metric))
        validateattributes(record.(metric),{'numeric'},{'scalar','real','finite','positive'});
    end
end
db.append('Performance_Data',struct2table(record));
end
