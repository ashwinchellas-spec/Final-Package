function r = TF_Model(e,f)
%TF_MODEL Turbofan architecture entry point to the shared cycle.
% Inputs: engine struct e and flight struct f. Output: SI result r.
% Ref: ABACUS 17. Model errors propagate; incorrect architecture is rejected.
if ~contains(e.Type,'Turbofan'), error('ABACUS:Architecture','TF_Model needs a Turbofan engine.'); end
r = gas_turbine_cycle(e,f);
end
