function f = flight_condition(altitude_m, mach, throttle, convention, afterburner)
%FLIGHT_CONDITION Standardised flight input, accepting geometric or geopotential m.
% Inputs: altitude [m], Mach [-], throttle [0,1], convention, optional AB flag.
% Output: f with both altitude conventions. Ref: ABACUS 16. Rejects invalid values.
if nargin < 4, convention = 'geometric'; end
if nargin < 5, afterburner = false; end
validateattributes(altitude_m,{'numeric'},{'real','finite','scalar'});
validateattributes(mach,{'numeric'},{'real','finite','scalar'});
validateattributes(throttle,{'numeric'},{'real','finite','scalar'});
if altitude_m<0, error('ABACUS:ERR_ATM_01','Altitude cannot be negative.'); end
if mach<0 || mach>3, error('ABACUS:ERR_MACH_01','Mach must be between zero and three.'); end
if throttle<0 || throttle>1, error('ABACUS:ERR_IN_01','Throttle must be between zero and one.'); end
validateattributes(afterburner,{'numeric','logical'},{'scalar','binary'});
c = project_config();
switch lower(string(convention))
    case "geometric"
        if altitude_m > 32000, error('ABACUS:ERR_ATM_01','Geometric altitude must be 0 to 32000 m.'); end
        h = altitude_m; H = c.EarthRadius_m*h/(c.EarthRadius_m+h);
    case "geopotential"
        if altitude_m > 32000, error('ABACUS:ERR_ATM_01','Geopotential altitude must be 0 to 32000 m.'); end
        H = altitude_m; h = c.EarthRadius_m*H/(c.EarthRadius_m-H);
    otherwise
        error('ABACUS:AltitudeConvention','Choose geometric or geopotential altitude.');
end
f = struct('Altitude_m',h,'GeopotentialAltitude_m',H,'Mach',mach,...
    'Throttle',throttle,'Afterburner',logical(afterburner),'Input_Convention',char(convention));
end
