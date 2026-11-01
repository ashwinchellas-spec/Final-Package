function s = compress_stage(Tin,Pin,ratio,eta,cp,gamma)
%COMPRESS_STAGE Isentropic-efficiency compression in total properties.
% Inputs: Tin K, Pin Pa, pressure ratio, eta, cp J/kg/K, gamma. Output: stage struct.
% Ref: ABACUS 17.2.2; throws on nonphysical conditions. Work is J/kg of stage flow.
if min([Tin,Pin,cp])<=0 || ratio<1 || eta<=0 || eta>1 || gamma<=1
    error('ABACUS:Compressor','Invalid compressor inputs.');
end
Tout = Tin*(1+(ratio^((gamma-1)/gamma)-1)/eta);
s = struct('Tt_K',Tout,'Pt_Pa',Pin*ratio,'Work_Jkg',cp*(Tout-Tin));
end
