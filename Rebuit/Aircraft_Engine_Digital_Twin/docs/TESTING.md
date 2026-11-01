# Testing and verification

## Executed evidence

The host audit uses Node.js built-in SQLite and static source inspection. Its recorded runtime is Node.js v24.19.0; timestamp 2026-09-16T01:46:16.330Z. It passed 28 checks and failed 0. This does not run MATLAB code. The actual evidence is reports/HOST_AUDIT_RESULTS.json.

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

## MATLAB tests included, not executed here

There are 64 test functions across eight suites. Fixtures create separate temporary databases. Optional GUI, Simulink or toolbox prerequisites are treated as incomplete/skipped tests, not passes. No matlab_test_results.csv is shipped because there was no MATLAB test run.

### TestAtmosphere.m

- testSeaLevel
- testGeopotentialCheckpoints
- testLayerContinuity
- testGeometricConversion
- testMachStagnation
- testNegativeAltitude
- testUpperBound
- testInvalidMachAndThrottle

### TestDatabase.m

- testAllTablesAndEngines
- testSeedIdempotent
- testProvenanceAudit
- testForeignKeyFailure
- testLiteralTextRoundTrip
- testAtomicRollback
- testImmutableReference
- testMissingProvenanceRejected
- testInvalidEngineID
- testSchemaConstraints

### TestEngines.m

- testIdealCompressionCheckpoint
- testNozzleChoked
- testNozzleUnchoked
- testNozzleBoundaryContinuity
- testNoExpansionRejected
- testAllCoreEnginesSLS
- testTurbofanMassAndFanDemand
- testTurbopropPowerAndStaticCase
- testPropellerContinuousAndFinite
- testKaveriWarningAndType
- testAltitudeAndMachEnvelope
- testAfterburnerRejected
- testBadEfficiencyAndTemperature
- testPistonPowerTorqueAndAltitude
- testZeroThrottleState
- testChangedParametersInvalidateFingerprint

### TestGUI.m

- testEightTabsAndKaveriWarning

### TestIntegration.m

- testPersistenceAndLog
- testFailedPointLogsWithoutPerformance
- testLogImmutable
- testArchitectureGridCounts
- testGridValidityMaskAndTemperatureFields
- testCompatibleComparison
- testIncompatibleComparisonRejected
- testAllMissionPresets
- testUnverifiedReferencesCannotPass
- testReportingContainsProvenance
- testOutputUnitConversion
- testHTMLTextEscaped

### TestML.m

- testSplitDeterministicAndDisjoint
- testDuplicateInputsRejected
- testMetricsKnownErrors
- testConstantAndZeroTargets
- testPolynomialTrainPredict
- testFourCandidateAPIs
- testMLCellRejectsHolesAndExtrapolation
- testMissingModelAndGate

### TestMission.m

- testNormalisationDirections
- testTieAndSingleMetric
- testAllEliminated
- testOnlyOneSurvives
- testHighScoreCannotOverrideConstraint
- testArchitectureAndCeiling
- testWeightsRejected
- testMixedSFCRejected

### TestSimulink.m

- testBuiltModelsMatchBackend

## Run in MATLAB

```matlab
setup_project;
installation = verify_project;
results = run_all_tests;
phaseResults = run_phase_tests(7);
dependencies = audit_dependencies;
validation = validate_physics;
```

Review every Failed and Incomplete result. A source parser cannot verify toolbox licensing, native SQLite types, GUI layout or S-function execution. The phase runner reuses meaningful suites instead of creating duplicate implementation-mirroring tests. For complete acceptance use run_all_tests, not only a single phase suite.

## Reference and regression checks

Track A compares exact reference conditions and reports real discrepancies without fitting. Unverified sources cannot receive PASS. Reviewed estimated targets remain explicitly academic. Track B reports real held-out surrogate error after training. regression_baseline('capture') requires passing internal tests and refuses to replace an existing baseline; regression_baseline('compare') uses a 0.01% relative-change threshold. A baseline is an executed software-regression artifact, not an independent engine measurement. parameter_sensitivity varies explicit model inputs and reports changes without claiming experimental uncertainty.

## Optional host reproduction

```bash
node scripts/audit_host.mjs .
```

Requires Node.js 24+. Its prepared-value roundtrip checks SQL/storage semantics through Node; the separate MATLAB typed-value roundtrip test must still execute with Database Toolbox.
