function valid = ml_domain_valid(bundle,f)
%ML_DOMAIN_VALID Require a query to lie inside a cell with valid physics at every corner.
% Inputs: bundle grid/mask and standard flight f. Output: logical, no extrapolation.
% Units: H m, Mach, throttle. Bounding-box-only interpolation across rejected holes is prohibited.
axesValues={bundle.Grid.Altitude_m,bundle.Grid.Mach,bundle.Grid.Throttle};
values=[f.GeopotentialAltitude_m,f.Mach,f.Throttle]; indices=cell(1,3); valid=false;
for d=1:3
    axis=axesValues{d}; x=values(d);
    if ~isfinite(x) || x<min(axis) || x>max(axis), return; end
    lower=find(axis<=x,1,'last'); upper=find(axis>=x,1,'first'); indices{d}=unique([lower,upper]);
end
mask=bundle.ValidityMask(indices{1},indices{2},indices{3}); valid=all(mask(:));
end
