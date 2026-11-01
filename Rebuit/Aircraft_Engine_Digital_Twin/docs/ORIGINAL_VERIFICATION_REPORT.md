# FINAL VERIFICATION REPORT

Project: Aircraft Engine Performance Analysis, Digital Twin, Machine Learning and Intelligent Engine Selection System (ABACUS v1.1 implementation).

Delivery date: 2026-09-16 UTC.

## Decision

**WARNING - implementation delivered; full MATLAB runtime acceptance remains outstanding.**

All 15 requested implementation areas are represented by integrated source, relevant tests and documentation. No phase is called complete solely because files exist. The host actually executed 28 SQL/static checks: 28 PASS, 0 FAIL. There are 93 MATLAB source files and 64 test functions. MATLAB/Octave, the GUI, Simulink and ML training were unavailable and are **NOT EXECUTED**. No measured performance, trained model, accuracy or validation success is fabricated.

The supplied database is a real SQLite file with reproducible schema/seed, not an empty sample. Both production and test copies passed integrity and foreign-key checks. The default seed contains 11 engines, 192 matching numeric provenance rows, 13 unverified secondary reference points and 7 missions. Optional piston seeding was tested through host SQLite and yields 13 engines.

## Status definitions

- PASS: the named, narrowly scoped check actually executed and passed.
- WARNING: implementation or evidence exists, but a material limitation or acceptance requirement remains.
- NOT EXECUTED: the stated runtime/test was not available or run.

## Executed checks

| Check | Status |
| --- | --- |
| Fresh schema and seed execute | PASS |
| Eleven core engines | PASS |
| Required tables, metadata, views and indexes | PASS |
| Reproducible idempotent seed | PASS |
| Foreign keys explicitly enabled | PASS |
| Foreign-key violations rejected | PASS |
| Database integrity and FK checks | PASS |
| Every numeric parameter has matching provenance and unit | PASS |
| No unverified manufacturer/type-certificate claims | PASS |
| Kaveri provenance remains Low/Estimated or Assumed | PASS |
| Missing TSFC not fabricated | PASS |
| All four data types accepted, invalid enum rejected | PASS |
| Reference records immutable | PASS |
| Simulation log append-only | PASS |
| Transaction rollback | PASS |
| Quoted text survives prepared-value roundtrip | PASS |
| Efficiency, OPR and mission weight constraints | PASS |
| Six PDF missions plus requested Trainer | PASS |
| Optional piston seed is separate and reproducible | PASS |
| Delivered engine_analysis.db integrity | PASS |
| Delivered engine_test.db integrity | PASS |
| Unique public MATLAB filenames | PASS |
| No forbidden unfinished implementation markers | PASS |
| No hardcoded author workspace paths in MATLAB | PASS |
| MATLAB source entry names match filenames | PASS |
| GUI dispatched action registry has handlers | PASS |
| Simulink wrapper and model references exist | PASS |
| Regression and ML gates are implemented | PASS |

The audit evidence, timestamp and exact scope are in reports/HOST_AUDIT_RESULTS.json. Source parsing evidence is in reports/SOURCE_PARSE_RESULTS.json. A syntax/static pass does not prove numerical correctness or MATLAB API execution.

## Included test inventory

| Suite | Tests | Execution |
| --- | --- | --- |
| TestAtmosphere.m | 8 | NOT EXECUTED |
| TestDatabase.m | 10 | NOT EXECUTED |
| TestEngines.m | 16 | NOT EXECUTED |
| TestGUI.m | 1 | NOT EXECUTED |
| TestIntegration.m | 12 | NOT EXECUTED |
| TestML.m | 8 | NOT EXECUTED |
| TestMission.m | 8 | NOT EXECUTED |
| TestSimulink.m | 1 | NOT EXECUTED |

The full test names appear in docs/TESTING.md. Tests cover atmosphere layers/bounds, SQL integrity/rollback/provenance, energy/mass balance, nozzle choking, engine zero-throttle and invalid inputs, grid shape, comparison compatibility, mission hard filtering and tie cases, ML splitting/metrics/domain/gates, GUI callbacks and Simulink-backend agreement. Some algorithm API tests use simple synthetic mathematical arrays; those are test fixtures, not engine performance claims.

## Delivery limitations

The GUI is a programmatic AppBase .m application, not a .mlapp Design View archive. Simulink includes three .mdl definitions plus an executable .slx builder; no .slx has been generated here. All engine seed parameters remain Estimated/Assumed and Low; none was independently manufacturer-verified. Default ML training is blocked until actual physics tests and source-reviewed, in-tolerance Track A comparisons pass. No pretrained models or fabricated certificates are included.

Steady-state constant-property models do not include afterburners, detailed component/propeller maps, bleed/cooling, variable geometry, degradation, transients, hardware, certification or aircraft drag/range. The technical report documents implementation and source, not a completed experimental validation study. Source and GitHub-ready metadata are delivered without an invented repository history.

## Next acceptance commands

Run from the extracted project root in MATLAB R2023b or newer:

```matlab
setup_project;
verify_project;
run_all_tests;
validate_physics;
run_project('gui');
```

Review actual results and unresolved reference errors before ML training. Install Simulink before build_simulink_models and run_simulink_model. See README.md for the complete workflow.

## Per-phase traceability

Statuses distinguish implementation from execution. No entire physics, ML or GUI phase is marked PASS based on source presence.

| Phase | Area | Status |
| --- | --- | --- |
| 1 | Database and project infrastructure | PASS for executed host SQL subchecks; WARNING for phase acceptance |
| 2 | ISA atmosphere | NOT EXECUTED |
| 3 | Piston physics | NOT EXECUTED |
| 4 | Turbojet physics | NOT EXECUTED |
| 5 | Turbofan physics | NOT EXECUTED |
| 6 | Turboprop physics | NOT EXECUTED |
| 7 | Physics validation and automated testing | WARNING |
| 8 | Digital Twin coordinator | NOT EXECUTED |
| 9 | Performance grids | NOT EXECUTED |
| 10 | Comparison and analysis | NOT EXECUTED |
| 11 | Mission-based selection | NOT EXECUTED |
| 12 | ML dataset generation | NOT EXECUTED |
| 13 | ML surrogate training and evaluation | NOT EXECUTED |
| 14 | MATLAB GUI | NOT EXECUTED |
| 15 | Full integration and reports | WARNING |

## PHASE 1 - Database and project infrastructure

**Status: PASS for executed host SQL subchecks; WARNING for phase acceptance**

Files: `setup_project.m`, `project_paths.m`, `matlab/setup`, `database/schema.sql`, `database/seed_data.sql`, `database/engine_analysis.db`, `database/engine_test.db`.

Dependencies: MATLAB R2023b, Database Toolbox.

Included test suites: TestDatabase.m.

Actually executed / reviewed: 28 host audit checks include real SQLite creation, seed, constraints, rollback, provenance and delivered-file integrity. MATLAB native connection/write APIs are NOT EXECUTED.

Known limitations and unresolved issues: Native SQLite typed operations replace JDBC-specific examples. Runtime API acceptance remains open.

Test cases in the applicable shared suites:

- TestDatabase.m: testAllTablesAndEngines, testSeedIdempotent, testProvenanceAudit, testForeignKeyFailure, testLiteralTextRoundTrip, testAtomicRollback, testImmutableReference, testMissingProvenanceRejected, testInvalidEngineID, testSchemaConstraints.

## PHASE 2 - ISA atmosphere

**Status: NOT EXECUTED**

Files: `matlab/atmosphere/ISA_model.m`, `matlab/utilities/flight_condition.m`.

Dependencies: project_config.

Included test suites: TestAtmosphere.m.

Actually executed / reviewed: Static source review only. No MATLAB atmosphere results were executed.

Known limitations and unresolved issues: Geometric/geopotential convention and inconsistent blueprint checkpoints are explicitly corrected.

Test cases in the applicable shared suites:

- TestAtmosphere.m: testSeaLevel, testGeopotentialCheckpoints, testLayerContinuity, testGeometricConversion, testMachStagnation, testNegativeAltitude, testUpperBound, testInvalidMachAndThrottle.

## PHASE 3 - Piston physics

**Status: NOT EXECUTED**

Files: `matlab/engines/piston/Piston_Model.m`, `database/seed_piston_extension.sql`, `matlab/setup/db_seed_piston_extension.m`.

Dependencies: Phase 1, Phase 2, propeller_model.

Included test suites: TestEngines.m.

Actually executed / reviewed: Host SQL check confirmed optional seed yields 13 engines. MATLAB physics was not executed.

Known limitations and unresolved issues: Opt-in extension outside PDF core; assumed naturally aspirated parameters.

Test cases in the applicable shared suites:

- TestEngines.m: testIdealCompressionCheckpoint, testNozzleChoked, testNozzleUnchoked, testNozzleBoundaryContinuity, testNoExpansionRejected, testAllCoreEnginesSLS, testTurbofanMassAndFanDemand, testTurbopropPowerAndStaticCase, testPropellerContinuousAndFinite, testKaveriWarningAndType, testAltitudeAndMachEnvelope, testAfterburnerRejected, testBadEfficiencyAndTemperature, testPistonPowerTorqueAndAltitude, testZeroThrottleState, testChangedParametersInvalidateFingerprint.

## PHASE 4 - Turbojet physics

**Status: NOT EXECUTED**

Files: `matlab/engines/turbojet/TJ_Model.m`, `matlab/engines/common`.

Dependencies: Phase 1, Phase 2.

Included test suites: TestEngines.m.

Actually executed / reviewed: Common cycle/component source reviewed; MATLAB mass/energy and nozzle tests unexecuted.

Known limitations and unresolved issues: Constant properties and algebraic off-design flow; no afterburner.

Test cases in the applicable shared suites:

- TestEngines.m: testIdealCompressionCheckpoint, testNozzleChoked, testNozzleUnchoked, testNozzleBoundaryContinuity, testNoExpansionRejected, testAllCoreEnginesSLS, testTurbofanMassAndFanDemand, testTurbopropPowerAndStaticCase, testPropellerContinuousAndFinite, testKaveriWarningAndType, testAltitudeAndMachEnvelope, testAfterburnerRejected, testBadEfficiencyAndTemperature, testPistonPowerTorqueAndAltitude, testZeroThrottleState, testChangedParametersInvalidateFingerprint.

## PHASE 5 - Turbofan physics

**Status: NOT EXECUTED**

Files: `matlab/engines/turbofan/TF_Model.m`, `matlab/engines/common/gas_turbine_cycle.m`.

Dependencies: Phase 4 components.

Included test suites: TestEngines.m.

Actually executed / reviewed: Static station, split-flow and work-demand review; no MATLAB execution.

Known limitations and unresolved issues: Separate exhaust, corrected fan work, no mixer or compressor map.

Test cases in the applicable shared suites:

- TestEngines.m: testIdealCompressionCheckpoint, testNozzleChoked, testNozzleUnchoked, testNozzleBoundaryContinuity, testNoExpansionRejected, testAllCoreEnginesSLS, testTurbofanMassAndFanDemand, testTurbopropPowerAndStaticCase, testPropellerContinuousAndFinite, testKaveriWarningAndType, testAltitudeAndMachEnvelope, testAfterburnerRejected, testBadEfficiencyAndTemperature, testPistonPowerTorqueAndAltitude, testZeroThrottleState, testChangedParametersInvalidateFingerprint.

## PHASE 6 - Turboprop physics

**Status: NOT EXECUTED**

Files: `matlab/engines/turboprop/TP_Model.m`, `matlab/engines/common/propeller_model.m`.

Dependencies: Phase 4 components.

Included test suites: TestEngines.m.

Actually executed / reviewed: Static gas-generator/free-turbine/propeller review; no MATLAB power/reference result.

Known limitations and unresolved issues: Assumed residual pressure and propeller geometry. Rating agreement unresolved.

Test cases in the applicable shared suites:

- TestEngines.m: testIdealCompressionCheckpoint, testNozzleChoked, testNozzleUnchoked, testNozzleBoundaryContinuity, testNoExpansionRejected, testAllCoreEnginesSLS, testTurbofanMassAndFanDemand, testTurbopropPowerAndStaticCase, testPropellerContinuousAndFinite, testKaveriWarningAndType, testAltitudeAndMachEnvelope, testAfterburnerRejected, testBadEfficiencyAndTemperature, testPistonPowerTorqueAndAltitude, testZeroThrottleState, testChangedParametersInvalidateFingerprint.

## PHASE 7 - Physics validation and automated testing

**Status: WARNING**

Files: `matlab/validation`, `run_all_tests.m`, `tests`.

Dependencies: Phases 1-6, matlab.unittest.

Included test suites: TestAtmosphere.m, TestEngines.m, TestDatabase.m.

Actually executed / reviewed: Host audit executed. MATLAB validation, sensitivity and regression baseline have NOT EXECUTED.

Known limitations and unresolved issues: No supplied verified primary engine targets, no accepted validation certificates.

Test cases in the applicable shared suites:

- TestAtmosphere.m: testSeaLevel, testGeopotentialCheckpoints, testLayerContinuity, testGeometricConversion, testMachStagnation, testNegativeAltitude, testUpperBound, testInvalidMachAndThrottle.
- TestEngines.m: testIdealCompressionCheckpoint, testNozzleChoked, testNozzleUnchoked, testNozzleBoundaryContinuity, testNoExpansionRejected, testAllCoreEnginesSLS, testTurbofanMassAndFanDemand, testTurbopropPowerAndStaticCase, testPropellerContinuousAndFinite, testKaveriWarningAndType, testAltitudeAndMachEnvelope, testAfterburnerRejected, testBadEfficiencyAndTemperature, testPistonPowerTorqueAndAltitude, testZeroThrottleState, testChangedParametersInvalidateFingerprint.
- TestDatabase.m: testAllTablesAndEngines, testSeedIdempotent, testProvenanceAudit, testForeignKeyFailure, testLiteralTextRoundTrip, testAtomicRollback, testImmutableReference, testMissingProvenanceRejected, testInvalidEngineID, testSchemaConstraints.

## PHASE 8 - Digital Twin coordinator

**Status: NOT EXECUTED**

Files: `matlab/digital_twin/DT_Coordinator.m`, `matlab/digital_twin/simulate_engine.m`, `matlab/setup/db_store_results.m`.

Dependencies: Phases 1-7, ML predictor for L5.

Included test suites: TestIntegration.m.

Actually executed / reviewed: Static L1-L5 dispatch/persistence/fallback review. MATLAB integration tests unexecuted.

Known limitations and unresolved issues: Academic steady-state coordinator; no live sensor connection.

Test cases in the applicable shared suites:

- TestIntegration.m: testPersistenceAndLog, testFailedPointLogsWithoutPerformance, testLogImmutable, testArchitectureGridCounts, testGridValidityMaskAndTemperatureFields, testCompatibleComparison, testIncompatibleComparisonRejected, testAllMissionPresets, testUnverifiedReferencesCannotPass, testReportingContainsProvenance, testOutputUnitConversion, testHTMLTextEscaped.

## PHASE 9 - Performance grids

**Status: NOT EXECUTED**

Files: `matlab/performance/performance_grid.m`, `matlab/performance/evaluate_grid.m`.

Dependencies: Phase 8.

Included test suites: TestIntegration.m.

Actually executed / reviewed: Configured cardinalities/source checked; full engine grids not generated.

Known limitations and unresolved issues: Invalid cells retained and excluded from training; some grid knots exceed an engine envelope by design.

Test cases in the applicable shared suites:

- TestIntegration.m: testPersistenceAndLog, testFailedPointLogsWithoutPerformance, testLogImmutable, testArchitectureGridCounts, testGridValidityMaskAndTemperatureFields, testCompatibleComparison, testIncompatibleComparisonRejected, testAllMissionPresets, testUnverifiedReferencesCannotPass, testReportingContainsProvenance, testOutputUnitConversion, testHTMLTextEscaped.

## PHASE 10 - Comparison and analysis

**Status: NOT EXECUTED**

Files: `matlab/comparison`, `matlab/reporting/plot_performance.m`, `matlab/reporting/plot_performance_map.m`.

Dependencies: Phase 8, Phase 9.

Included test suites: TestIntegration.m.

Actually executed / reviewed: Static metric compatibility and sorting review; numerical tables/plots not executed.

Known limitations and unresolved issues: No unconditional comparison of jet TSFC to propeller BSFC.

Test cases in the applicable shared suites:

- TestIntegration.m: testPersistenceAndLog, testFailedPointLogsWithoutPerformance, testLogImmutable, testArchitectureGridCounts, testGridValidityMaskAndTemperatureFields, testCompatibleComparison, testIncompatibleComparisonRejected, testAllMissionPresets, testUnverifiedReferencesCannotPass, testReportingContainsProvenance, testOutputUnitConversion, testHTMLTextEscaped.

## PHASE 11 - Mission-based selection

**Status: NOT EXECUTED**

Files: `matlab/mission`.

Dependencies: Phases 1,8,10.

Included test suites: TestMission.m.

Actually executed / reviewed: Host audit verifies seven mission seeds; MATLAB constraint/scoring tests unexecuted.

Known limitations and unresolved issues: Relative engine screening only; no airframe drag/range solver.

Test cases in the applicable shared suites:

- TestMission.m: testNormalisationDirections, testTieAndSingleMetric, testAllEliminated, testOnlyOneSurvives, testHighScoreCannotOverrideConstraint, testArchitectureAndCeiling, testWeightsRejected, testMixedSFCRejected.

## PHASE 12 - ML dataset generation

**Status: NOT EXECUTED**

Files: `matlab/ml/ml_generate_dataset.m`, `matlab/ml/ml_stratified_split.m`, `matlab/ml/ml_targets.m`.

Dependencies: Phase 7 acceptance, Phase 9.

Included test suites: TestML.m.

Actually executed / reviewed: Static gate/split/domain review. No accepted physics dataset generated.

Known limitations and unresolved issues: Default validation gate closed. Synthetic physics data only.

Test cases in the applicable shared suites:

- TestML.m: testSplitDeterministicAndDisjoint, testDuplicateInputsRejected, testMetricsKnownErrors, testConstantAndZeroTargets, testPolynomialTrainPredict, testFourCandidateAPIs, testMLCellRejectsHolesAndExtrapolation, testMissingModelAndGate.

## PHASE 13 - ML surrogate training and evaluation

**Status: NOT EXECUTED**

Files: `matlab/ml/ml_train_surrogates.m`, `matlab/ml/ml_fit_candidate.m`, `matlab/ml/ml_apply_candidate.m`, `matlab/ml/ml_predict.m`, `matlab/ml/ml_metrics.m`, `matlab/ml/ml_diagnostic_report.m`, `matlab/ml/ml_learning_curve.m`.

Dependencies: Phase 12, Statistics and Machine Learning Toolbox.

Included test suites: TestML.m.

Actually executed / reviewed: Static audit checked gate and validation-selection-before-test ordering. No training or performance benchmark executed.

Known limitations and unresolved issues: No trained MAT files or accuracy values. ANN uses fitrnet per output.

Test cases in the applicable shared suites:

- TestML.m: testSplitDeterministicAndDisjoint, testDuplicateInputsRejected, testMetricsKnownErrors, testConstantAndZeroTargets, testPolynomialTrainPredict, testFourCandidateAPIs, testMLCellRejectsHolesAndExtrapolation, testMissingModelAndGate.

## PHASE 14 - MATLAB GUI

**Status: NOT EXECUTED**

Files: `gui/EngineAnalyser_v1.m`, `gui/gui_build.m`, `gui/gui_action.m`, `gui`.

Dependencies: Phases 1-13, MATLAB desktop.

Included test suites: TestGUI.m.

Actually executed / reviewed: Host audit checks callback action registry and source references. No desktop walkthrough.

Known limitations and unresolved issues: Programmatic AppBase .m instead of .mlapp Design View artifact.

Test cases in the applicable shared suites:

- TestGUI.m: testEightTabsAndKaveriWarning.

## PHASE 15 - Full integration and reports

**Status: WARNING**

Files: `run_project.m`, `verify_project.m`, `scripts/audit_dependencies.m`, `scripts/run_phase_tests.m`, `simulink`, `matlab/reporting`, `docs`, `reports`.

Dependencies: All previous phases, Simulink for model execution.

Included test suites: TestIntegration.m, TestSimulink.m, TestGUI.m.

Actually executed / reviewed: 28 host checks passed. Documentation/PDF and archive checks are recorded separately. Full MATLAB/Simulink integration NOT EXECUTED.

Known limitations and unresolved issues: Text .mdl plus .slx builder; no generated .slx, real benchmark or fabricated publication history.

Test cases in the applicable shared suites:

- TestIntegration.m: testPersistenceAndLog, testFailedPointLogsWithoutPerformance, testLogImmutable, testArchitectureGridCounts, testGridValidityMaskAndTemperatureFields, testCompatibleComparison, testIncompatibleComparisonRejected, testAllMissionPresets, testUnverifiedReferencesCannotPass, testReportingContainsProvenance, testOutputUnitConversion, testHTMLTextEscaped.
- TestSimulink.m: testBuiltModelsMatchBackend.
- TestGUI.m: testEightTabsAndKaveriWarning.
