# Handover changes - 18 September 2026

## Source and database

Source archive: e69fd431-8831-4f3b-8f11-3b897d2c3789.zip. All original files are retained, with two intentional source edits below. Original .asv/.bak files are retained as historical files, not active launch dependencies.

The source archive omitted the working database. Added the subsequently supplied f33a1ce7-6f6e-4445-a427-8adab164f983.db, byte-for-byte, as Aircraft_Engine_Digital_Twin/database/engine_analysis.db. This database contains 13 engines, 180 Performance_Data rows, 209 Simulation_Log rows and 218 parameter provenance records. Integrity check returns ok; foreign-key check is empty; all 218 populated numerical parameters match their provenance values.

The other supplied database, 04812be9-cd09-4570-9c57-c2ebb0524250.db, is byte-identical to the archive's engine_test.db and was not substituted for the working database.

## Added

- LAUNCH_ABACUS.m: portable launch/check entry point. It verifies fingerprints and creates relocated copies of selected saved bundles in a new reports folder. It does not retrain, calibrate, rewrite the original models, or change validation gates.
- READ_ME_FIRST.md: startup and smoke-check instructions.
- FINAL_DOCUMENTATION: final report, evidence index and static audit results.
- SHA256SUMS.txt: distributed file inventory excluding itself.

## Edited

- ABACUS_GUI_EXPERIMENT/ATTACH_EXPERIMENTAL_ML.m: accepts an optional third predictorFile argument. Existing one-/two-argument file-selection workflows remain. Launcher can attach the tab without dialogs. Existing validity, status and fingerprint checks are unchanged.
- Aircraft_Engine_Digital_Twin/RUN_PENDING_STUDIES.m: plotting retains invalid/nonfinite rows as NaN instead of deleting them, preventing lines bridging rejected internal points in future runs. Historical CSVs and PNGs remain unchanged.

No files within matlab/engines, atmosphere, validation, utilities or setup were changed. No database calibration writes were performed. No existing ML model was promoted to operational status.

## Verification performed here

Archive CRC; required selected model-file presence; working database integrity, foreign keys and parameter/provenance agreement; CSV row counts and rejection categories; original-versus-candidate comparisons; source-diff inventory; final report text and rendered-page review; final ZIP CRC and SHA-256 manifest verification.

## Not executed here

MATLAB is unavailable in this environment. The new launcher, optional GUI argument and plotting edit have not been runtime-tested here. User-reported earlier MATLAB tests apply to the previous source version. Run LAUNCH_ABACUS('check') in a fresh MATLAB session before accepting relocation. The check retains stale-model rejection rather than repairing or bypassing it.
