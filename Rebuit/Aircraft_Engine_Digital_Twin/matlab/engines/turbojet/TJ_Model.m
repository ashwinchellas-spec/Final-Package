function r = TJ_Model(e,f)
%TJ_MODEL Turbojet architecture entry point to the shared cycle.
% Inputs: engine struct e and flight struct f. Output: SI result r.
% Ref: ABACUS 17. Model errors propagate; incorrect architecture is rejected.
if ~contains(e.Type,'Turbojet'), error('ABACUS:Architecture','TJ_Model needs a Turbojet engine.'); end
r = gas_turbine_cycle(e,f);
end
