# User manual

## Installation and first use

Extract the archive into a writable folder. In MATLAB R2023b or newer, set Current Folder to Aircraft_Engine_Digital_Twin. Install Database Toolbox. Run setup_project, verify_project and run_all_tests. The test runner writes actual Passed/Failed/Incomplete columns to reports/matlab_test_results.csv. Optional toolbox or desktop limitations may produce incomplete tests, which are not passes. Run run_project('gui') to open the application.

The first setup call preserves the provided seeded database and adds only the authoritative project source folders. You can create a separate database with setup_project(fullfile(tempdir,'my_abacus.db')). To use it in subsequent workflows, pass its filename explicitly to DT_Coordinator or EngineAnalyser_v1; calling run_project uses the standard project database.

## Eight application tabs

1. Engine Database Browser: select architecture/engine, inspect catalogue and per-parameter provenance. Source confidence appears with the selected engine.
2. Single-Point Analysis: enter geometric altitude in metres, Mach and throttle. Run physics at L4 or request L5. Inspect SI/display metrics, source label, warnings and station total conditions. No output exists before calculation.
3. Performance Envelope: generate altitude/Mach/throttle sweeps and architecture maps. Invalid cells remain flagged. Plot force, power or fuel metrics only where applicable.
4. Digital Twin Comparison: compare engines at a common flight condition and with one comparable metric. Jet TSFC and propeller BSFC are not interchangeable.
5. ML Surrogate Manager: generate gated data, train candidates and inspect actual metrics. Missing validation or unavailable models produces an actionable diagnostic.
6. Mission-Based Engine Selection: choose a preset or edit constraints and normalized weights, apply filtering, then inspect survivors, eliminations and score contributions.
7. Validation Report: execute physics tests and Track A comparison. Unverified secondary ratings remain WARNING. No table is preloaded with invented passes.
8. Settings and Export: change a compatible database, choose single-point SI/Imperial display, export CSV/MAT/PNG/PDF and create an HTML session report. GUI altitude entry and CSV remain SI.

The GUI calls backend functions; it contains no second implementation of the thermodynamic equations. It is provided as .m AppBase source and cannot be opened as a .mlapp in App Designer Design View. Runtime screen layout and callbacks still require desktop MATLAB acceptance.

## Command-line example

```matlab
setup_project;
dt = DT_Coordinator;
f = flight_condition(0,0,1);
r = dt.run(4,f,'L4',true);
disp(format_result_metrics(r,'SI'));
comparison = compare_engines(dt,[4,5],f,'Thrust_N');
mission = EngineSelector(dt,1,[],true);
reportFile = generate_report(r,comparison,mission,table());
delete(dt);
```

Check r.Valid and r.Warnings before interpreting a calculated metric. L1 can evaluate without persistence; L4 stores results and metadata. L5 attempts ML and labels any physics fallback. A separate engine-off convention applies at throttle zero.

## Mission presets

| Mission_ID | Mission_Name | Architectures | Altitude_m | Mach | Ceiling_m |
| --- | --- | --- | --- | --- | --- |
| 1 | Subsonic Commercial Transport | Turbofan_HighBPR | 11000 | 0.82 | 11000 |
| 2 | Air Superiority Fighter | Turbojet,Turbofan_LowBPR | 12000 | 1.2 | 12000 |
| 3 | Ground Attack / CAS | Turbojet,Turbofan_LowBPR | 5000 | 0.85 | 5000 |
| 4 | Maritime Patrol / ISR | Turboprop | 3000 | 0.45 | 3000 |
| 5 | STOL Transport | Turboprop | 2000 | 0.35 | 2000 |
| 6 | High-Altitude Reconnaissance | Turbojet,Turbofan_LowBPR | 20000 | 0.8 | 20000 |
| 7 | Academic Trainer | Turboprop | 1500 | 0.25 | 1500 |

The six PDF presets plus Trainer are academic screening examples. First apply architecture, flight-envelope, thrust/power, fuel-specific-consumption, weight and ceiling constraints. Only survivors are normalized and scored. An engine violating a hard condition cannot win. If no engine survives, the application says so; if exactly one survives, it reports feasibility without pretending a relative ranking. Identical criterion values score 0.5 and cannot distinguish candidates. Explanations show five weighted contributions. No aircraft drag, range or full mission fuel integration is included.

## Optional piston workflow

```matlab
setup_project;
db_seed_piston_extension;
app = run_project('gui');
```

The opt-in seed adds two Assumed/Low catalogue records. This is an extension to the PDF's 11-engine core. Use shaft power, BSFC, fuel flow and equivalent propulsive thrust for this architecture.

## Simulink workflow

```matlab
setup_project;
models = build_simulink_models;
out = run_simulink_model('ABACUS_Turbojet',[1;0;0;1]);
```

Input order is engine ID, geometric altitude m, Mach, throttle. The builder makes three connected .slx models, each with a constant operating point, Level-2 MATLAB S-function and workspace sink. The S-function calls the shared physics backend. Delivered .mdl files can be inspected before building. Stop time zero represents one equilibrium evaluation; running a longer Simulink time does not add engine dynamics. Close an existing model before rebuilding; the builder refuses to overwrite an open model's unsaved edits.

## Reporting and output locations

run_project('demo') creates a session report from real calculations once MATLAB runs. plots holds exported figures, tables contains CSV grids/analysis, results contains saved sessions and ml_models contains actual trained bundles. reports holds verification evidence and reports. The supplied technical report documents the implementation and includes source listings; it contains no claimed engine validation or experimental findings.

## Troubleshooting

If sqlite is unavailable, install/enable Database Toolbox. A release error requires R2023b or later. A schema error requires backing up the old database and deliberately migrating or choosing a new filename; do not delete a user's database blindly. A provenance error means a numerical parameter and its provenance are missing or inconsistent. A validation-required error is expected for ML with the default unverified references. A missing model warning during L5 results in physics fallback. Invalid operating points must be corrected or left invalid, not clipped into a different condition. If a Simulink wrapper fails, inspect the original backend diagnostic and run its corresponding MATLAB case first.
