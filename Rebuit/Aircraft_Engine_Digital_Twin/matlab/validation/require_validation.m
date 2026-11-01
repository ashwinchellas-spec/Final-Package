function certificate = require_validation(e)
%REQUIRE_VALIDATION Reject missing/stale/unaccepted physics sign-off before ML data.
% Input: loaded engine. Output: certificate struct. Units: none; no bypass flag.
% Ref: ABACUS CR-16; a generated source file never counts as executed validation.
p=project_paths(); file=fullfile(p.reports,sprintf('validation_engine_%d.json',e.ID));
if ~isfile(file), error('ABACUS:ValidationRequired','Run validate_physics and review Track A before training engine %d.',e.ID); end
certificate=jsondecode(fileread(file));
if ~strcmp(certificate.Fingerprint,e.Fingerprint)
    error('ABACUS:StaleValidation','Model/parameter provenance changed; rerun physics validation.');
end
if ~certificate.InternalTestsPassed || ~certificate.AcceptedForML
    error('ABACUS:ValidationRequired','Track A is not accepted for this engine. Review verified references and the actual model error; ML training is blocked.');
end
end
