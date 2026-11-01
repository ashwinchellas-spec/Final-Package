function t = evaluate_grid(e,altitudes,machs,throttles,db,persist,level)
%EVALUATE_GRID Evaluate validated points and retain diagnostics for rejected points.
% Inputs: engine; H [m], M, throttle vectors; optional DB/persistence; DT level.
% Output: flat table in SI. Invalid conditions are rejected before cycle evaluation.
if nargin<5, db=[]; end
if nargin<6, persist=false; end
if nargin<7, level='L3'; end
validateattributes(altitudes,{'numeric'},{'vector','real','finite','>=',0,'<=',32000});
validateattributes(machs,{'numeric'},{'vector','real','finite','>=',0,'<=',3});
validateattributes(throttles,{'numeric'},{'vector','real','finite','>=',0,'<=',1});
[H,M,theta]=ndgrid(altitudes,machs,throttles);
results=cell(numel(H),1); rows=cell(numel(H),1);
for i=1:numel(H)
    f=flight_condition(H(i),M(i),theta(i),'geopotential');
    results{i}=simulate_engine(e,f); rows{i}=result_row(results{i});
end
t=vertcat(rows{:});
if persist
    if isempty(db), error('ABACUS:Persistence','A DB connection is required for persistence.'); end
    db_store_results(db,results,level);
end
end
