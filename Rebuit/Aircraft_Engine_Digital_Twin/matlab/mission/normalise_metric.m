function [score,tied] = normalise_metric(value,higherBetter)
%NORMALISE_METRIC Min-max normalisation of FEASIBLE candidates only.
% Input: finite numeric vector, direction flag. Outputs: scores [-], tie flag.
% Ref: ABACUS 21.2. Equal values score 0.5; empty input returns an empty vector.
if nargin<2, higherBetter=true; end
if isempty(value), score=value; tied=false; return; end
validateattributes(value,{'numeric'},{'real','finite','vector'});
lo=min(value); hi=max(value); tied=(hi==lo);
if tied, score=.5*ones(size(value)); return; end
score=(value-lo)/(hi-lo);
if ~higherBetter, score=1-score; end
end
