function r = TP_Model(e,f)
%TP_MODEL Turboprop architecture entry point to the shared cycle.
% Inputs: engine struct e and flight struct f. Output: SI result r.
% Ref: ABACUS 17. Model errors propagate; incorrect architecture is rejected.
if ~contains(e.Type,'Turboprop'), error('ABACUS:Architecture','TP_Model needs a Turboprop engine.'); end
r = gas_turbine_cycle(e,f);
end
